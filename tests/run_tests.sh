#!/bin/bash
set -e
set -o pipefail
shopt -s nullglob
#set -x

helm repo update

if [ ! -z "$1" ]; then
	FLAG="$1"
fi

cd $(dirname $0)
chart_dir=$PWD/../charts/helm-chart-of-the-death/

# to test on a specific cluster using
# if .Capabilities.APIVersions.Has "objectbucket.io/v1alpha1"
# swith to $dryrun=server
# --dry-run=server allow lookup function and Capabilities on 4.x
dryrun=client

apiversions='--api-versions objectbucket.io/v1alpha1'

helm lint $chart_dir

# checking keep annotation. This prevent uninstall of all components in case of misused
for manifest in $(find $chart_dir/templates -type f -not -name "_*" -a -not -name "NOTES.txt"); do
  if ! grep "helm.sh/resource-policy: keep" $manifest >/dev/null; then
    echo "missing keep annotation in $manifest"
    exit 1
  fi
done

for values_helper in $(find $chart_dir/templates -type f -name "_values.tpl"); do
  if ! grep ".defaultValues" $values_helper >/dev/null; then
    echo "missing defaultValues in $values_helper"
  fi
  if ! grep ".mergedValues" $values_helper >/dev/null; then
    echo "missing mergedValues in $values_helper"
  fi
done

function helm_repo_add {
  file=$1
  if [ "$FLAG" == "repo" ]; then
    echo adding repo of $file
    repo=$(cat $file | yq '.metadata.name')
    url=$(cat $file | yq '.spec.url')
    if [ $repo != "null" ]; then
      helm repo add $repo $url
    fi
  else
    echo "repo add disabled, re-run with repo arg if needed"
  fi
}

for dir in test-*; do
  echo '=================================================='
  echo testing $dir
  (
    cd $dir
    rm -rf render_1 render_2
    mkdir render_1 render_2
    (
      cd render_1
      helm template all-in-one $chart_dir --dry-run=$dryrun $apiversions -f ../values.yaml | yq -s '.kind + "-" + .metadata.namespace + "-" + .metadata.name'
    )

    # add helm repos
    for repo in render_1/HelmRepository-*.yml; do
      helm_repo_add $repo
    done

    for release in render_1/HelmRelease-*.yml; do
      echo testing render of $release

      # extract values
      cat $release | yq '.spec.values' > $release.values

      # extract chart infos
      chart=$(cat $release | yq '.spec.chart.spec.chart')
      version=$(cat $release | yq '.spec.chart.spec.version')
      repokind=$(cat $release | yq '.spec.chart.spec.sourceRef.kind')
      repo=$(cat $release | yq '.spec.chart.spec.sourceRef.name')
      name=$(cat $release | yq '.metadata.name')
      namespace=$(cat $release | yq '.metadata.namespace')

      # output file
      dest=$(echo "$release" | sed -e 's/render_1/render_2/')

      if [ "$chart" == "null" ]; then
        echo component not enabled >/dev/null
      else
        # TODO: do it in the namespace
        if [ "$repokind" == "HelmRepository" ]; then
          repo_options="$repo/$chart --version=$version"
        elif [ "$repokind" == "OCIRepository" ]; then
          repo_url=$(cat render_1/${repokind}-default-${repo}.yml | yq '.spec.url')
          repo_tag=$(cat render_1/${repokind}-default-${repo}.yml | yq '.spec.ref.tag')
          repo_options="$repo_url --version $repo_tag"
        else
          echo "Unsupported $repokind"
          cat $release | yq '.spec.chart.spec'
          exit 1
        fi
        
        helm -n $namespace template $name $repo_options --dry-run=$dryrun $apiversions -f $release.values > $dest
      fi

    done
  )
done

git diff

{{- /*
common.merge : custom merge function
args: $obj1 $obj2 $conf
*/}}
{{- define "common.merge" }}

  {{- /* check input type */}}
  {{- if not (kindIs "slice" .) }}
    {{- fail "common.merge: bad arg" }}
  {{- end }}
  
  {{- /* check input length */}}
  {{- if not (eq (len .) 3) }}
    {{- fail "common.merge: bad arg length" }}
  {{- end }}
  
  {{- /* define vars */}}
  {{- $obj1 := (index . 0) }}
  {{- $obj2 := (index . 1) }}
  {{- $conf := (index . 2) }}


  {{- $strategy := "append" }}
  {{- if (kindIs "map" $conf) }}
    {{- $strategy = $conf.strategy | default "append" }}
  {{- end }}
  
  {{- if or 
         (kindIs "int" $obj1)
         (kindIs "float64" $obj1)
         (kindIs "string" $obj1)
  }}
    {{- fail "Deprecated" }}
  
  
  {{- else if (kindIs "map" $obj1) }}
    {{- range $key,$value := merge $obj1 $obj2 }}
      {{- $value1 := dig $key nil $obj1 }}
      {{- $value2 := dig $key nil $obj2 | default dict }}
      {{- $conf := dig $key nil $conf | default dict }}

      {{- if or
               (kindIs "float64" $value1)
               (kindIs "string" $value1)
             }}
{{- /*
debug_value1_kind: {{ typeOf $value1 }}
debug_value1: {{ $value1 }}
debug_value2: {{ $value2 }}
*/}}
        {{- if $value2 }}
          {{- $key | nindent 0 }}: {{ $value2 }}
        {{- else }}
          {{- $key | nindent 0 }}: {{ $value1 }}
        {{- end }}

      {{- else if or
               (kindIs "bool" $value1)
             }}
{{- /*
debug_value1_kind: {{ typeOf $value1 }}
debug_value1: {{ $value1 }}
debug_value2: {{ $value2 }}
*/}}
        {{- $value1 := dig $key nil $obj1 }}
        {{- $value2 := dig $key nil $obj2 }}
        {{- if (kindIs "bool" $value2) }}
          {{- $key | nindent 0 }}: {{ $value2 }}
        {{- else }}
          {{- $key | nindent 0 }}: {{ $value1 }}
        {{- end }}


      {{- else if or
                     (kindIs "slice" $value1)
                     (kindIs "map" $value1)
             }}
      {{- $result_value := include "common.merge" (list $value1 $value2 $conf) }}
      {{- $key | nindent 0 }}:
        {{- $result_value | nindent 2 }}
      {{- else }}
      {{ fail printf "TODO kind %s" (typeOf $value1) }}
      {{- end }}

    {{- end }}
  
  
  {{- else if (kindIs "slice" $obj1) }}

    {{- if eq $strategy "merge" }}
      {{- $mergeKey := $conf.mergeKey | required "missing merge key" }}
      {{- $keys := list }}
      {{- range $obj1 }}
        {{- $keyValue := dig $mergeKey nil . }}
        {{- if not $keyValue }}
          {{- fail "object without required key in slice" }}
        {{- end }}
        {{- $keys = append $keys $keyValue }}
      {{- end }}
      {{- range $obj2 }}
        {{- $keyValue := dig $mergeKey nil . }}
        {{- if not $keyValue }}
          {{- fail "object without required key in slice" }}
        {{- end }}
        {{- $keys = append $keys $keyValue }}
      {{- end }}
      {{- $keys = uniq $keys }}

      {{- /* search each key in obj2 else obj1 */}}
      {{- $result := list }}
      {{- range $key := $keys }}
        {{- $obj := dict }}
        {{- range $obj2 }}
          {{- $keyValue := dig $mergeKey nil . }}
          {{- if eq $keyValue $key }}
            {{- $obj = . }}
          {{- end }}
        {{- end }}
        {{- if not $obj }}
          {{- range $obj1 }}
            {{- $keyValue := dig $mergeKey nil . }}
            {{- if eq $keyValue $key }}
              {{- $obj = . }}
            {{- end }}
          {{- end }}
        {{- end }}
        {{- $result = append $result $obj }}
      {{- end }}
      {{- toYaml $result }}

      
    {{- else if eq $strategy "append" }}
      {{- $result := list }}
      {{- range $obj1 }}
      {{- $result = append $result . }}
      {{- end }}
      {{- range $obj2 }}
      {{- $result = append $result . }}
      {{- end }}
      {{- toYaml $result }}

    {{- else if eq $strategy "overwrite" }}
      {{- $result := list }}
      {{- range $obj2 }}
      {{- $result = append $result . }}
      {{- end }}
      {{- toYaml $result }}

    {{- else }}
      {{- fail (printf "unknown strategy %s" $strategy) }}
    {{- end }}
    
  {{- else }}
TODO2: other {{ kindOf $obj1 }}
  {{- end }}
  
{{- end }}

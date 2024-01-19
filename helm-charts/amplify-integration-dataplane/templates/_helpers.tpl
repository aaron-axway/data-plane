{{- define "parent.dataplaneMode" -}}
{{- (eq .Values.global.clusterKey "") | ternary "shared" (printf "%s" (.Values.global.clusterKey | b64dec | fromJson).mode) }}
{{- end }}

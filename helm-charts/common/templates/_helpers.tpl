{{- define "common.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "common.appName" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- $env := default .Chart.Name .Values.global.appEnv -}}
{{- printf "%s-%s" $name $env  | trunc 63 | trimSuffix "-" -}}
{{- end }}

{{- define "parent.dataplaneMode" -}}
{{- (eq .Values.global.clusterKey "") | ternary "shared" (printf "%s" (.Values.global.clusterKey | b64dec | fromJson).mode) }}
{{- end }}
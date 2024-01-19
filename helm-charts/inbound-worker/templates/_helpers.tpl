{{/*
Expand the name of the chart.
*/}}
{{- define "inbound-worker.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "parent.dataplaneMode" -}}
{{- (eq .Values.global.clusterKey "") | ternary "shared" (printf "%s" (.Values.global.clusterKey | b64dec | fromJson).mode) }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "inbound-worker.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "inbound-worker.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "inbound-worker.labels" -}}
app: {{ include "inbound-worker.appName" . }}
chart: {{ include "inbound-worker.chart" . }}
release: {{ .Release.Name }}
heritage: {{ .Release.Service }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "inbound-worker.selectorLabels" -}}
app: {{ include "inbound-worker.appName" . }}
release: {{ .Release.Name }}
dplane: "{{ .Chart.Name }}"
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "inbound-worker.serviceAccountName" -}}
{{- if .Values.serviceAccount.enabled }}
{{- default (include "inbound-worker.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Custom templates start here 
*/}}

{{- define "inbound-worker.appName" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- $env := default .Chart.Name .Values.global.appEnv -}}
{{- printf "%s-%s" $name $env  | trunc 63 | trimSuffix "-" -}}
{{- end }}

{{/*
Image name
*/}}
{{- define "image.finalname" -}}
{{- printf "%s/%s:%s" .Values.image.server .Chart.Name .Chart.AppVersion }}
{{- end }}

{{/*
Cpu min request
*/}}
{{- define "microserviceChart.minCpuUnits" -}}
"
{{- index .Values.valuesPerEnvironment.cpuUnits ((pluck .Values.environment .Values.environments | first | default .Values.environments.sandbox) | int) -}}
m"
{{- end }}
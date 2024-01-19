{{/*
Expand the name of the chart.
*/}}
{{- define "orchestrator.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "orchestrator.fullname" -}}
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
{{- define "orchestrator.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "orchestrator.labels" -}}
app: {{ include "orchestrator.appName" . }}
chart: {{ include "orchestrator.chart" . }}
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
{{- define "orchestrator.selectorLabels" -}}
app: {{ include "orchestrator.appName" . }}
release: {{ .Release.Name }}
dplane: "orchestrator"
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "orchestrator.serviceAccountName" -}}
{{- if .Values.serviceAccount.enabled }}
{{- default (include "orchestrator.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Custom templates start here 
*/}}

{{- define "orchestrator.appName" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- $env := default .Chart.Name .Values.global.appEnv -}}
{{- printf "%s-%s" $name $env | trunc 63 | trimSuffix "-" -}}
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
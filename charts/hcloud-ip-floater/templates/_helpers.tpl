{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "hcloud-ip-floater.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "hcloud-ip-floater.fullname" -}}
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
{{- define "hcloud-ip-floater.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "hcloud-ip-floater.labels" -}}
helm.sh/chart: {{ include "hcloud-ip-floater.chart" . }}
{{ include "hcloud-ip-floater.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "hcloud-ip-floater.selectorLabels" -}}
app.kubernetes.io/name: {{ include "hcloud-ip-floater.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "hcloud-ip-floater.serviceAccountName" -}}
{{- if and .Values.rbac.create .Values.rbac.serviceAccount.create -}}
{{- default (include "hcloud-ip-floater.fullname" .) .Values.rbac.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.rbac.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the secret to use for hcloud api token
*/}}
{{- define "hcloud-ip-floater.secretName" -}}
{{- if .Values.secret.create -}}
{{- printf "%s-%s" (include "hcloud-ip-floater.fullname" .) .Values.secret.name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- .Values.secret.name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

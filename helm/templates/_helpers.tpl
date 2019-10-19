{{/* vim: set filetype=mustache: */}}

{{- define "django.fullname" -}}
{{- printf "%s-%s" "orihime-django" .Release.Name  | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "trie.fullname" -}}
{{- printf "%s-%s" "goo-trie" .Release.Name  | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "dict.fullname" -}}
{{- printf "%s-%s" "goo-dict" .Release.Name  | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "mod.fullname" -}}
{{- printf "%s-%s" "mod-goo" .Release.Name  | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "orihime.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "orihime.imageTag" -}}
{{- .Values.imageTagOverride | default .Release.Name -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "orihime.labels" -}}
app.kubernetes.io/name: "orihime"
helm.sh/chart: {{ include "orihime.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

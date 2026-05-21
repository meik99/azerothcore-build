{{/*
Parse repository name from a GitHub URI.

Example:
  https://github.com/azerothcore/mod-autobalance.git
returns:
  mod-autobalance
*/}}
{{- define "repo.nameFromUri" -}}
{{- $uri := . | trim -}}
{{- $repo := $uri | trimSuffix "/" | splitList "/" | last -}}
{{- $repo | trimSuffix ".git" -}}
{{- end -}}
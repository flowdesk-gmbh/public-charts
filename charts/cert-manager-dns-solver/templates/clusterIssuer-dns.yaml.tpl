apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: {{ include "solver.fullname" . }}-dns
  labels:
    {{- include "solver.labels" . | nindent 4 }}
  {{- with .Values.annotations }}
  annotations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
spec:
  acme:
    {{- .Values.acme | toYaml | nindent 4 }}
    solvers:
    {{- $defaultRegion := .Values.route53.region -}}
    {{- range .Values.route53.zones }}
      - selector:
          dnsZones:
            - {{ .name }}
        dns01:
          route53:
            hostedZoneID: {{ .hostedZoneID }}
            {{- if .region }}
            region: {{ .region }}
            {{- else }}
            region: {{ $defaultRegion }}
            {{- end }}
    {{- end }}

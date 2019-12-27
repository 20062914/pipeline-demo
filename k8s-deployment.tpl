apiVersion: apps/v1
kind: Deployment
metadata:
  name: {APP_NAME}-deployment
  labels:
    app: {APP_NAME}
spec:
  replicas: 3
  selector:
    matchLabels:
      app: {APP_NAME}
  template:
    metadata: 
      labels:
        app: {APP_NAME}
    spec:
      containers:
      - name: {APP_NAME}
        image: {IMAGE_URL}:{IMAGE_TAG}
        ports:
        - containerPort: 40080
        env:
          - name: SPRING_PROFILES_ACTIVE
            value: {SPRING_PROFILE}
      imagePullSecrets:
      - name: regcred
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 25%
      maxSurge: 25%
  revisionHistoryLimit: 10
  progressDeadlineSeconds: 600
---
apiVersion: v1
kind: Service
metadata:
  name: {APP_NAME}-service
  labels:
    app: {APP_NAME}
spec:
  type: NodePort
  sessionAffinity: ClientIP
  ports:
  - port: 40080
    protocol: TCP
    targetPort: 40080
    nodePort: 30004
  selector:
    app: {APP_NAME}
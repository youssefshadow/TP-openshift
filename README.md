# Déploiement OpenShift — Angular + json-server

Ce dépôt contient un exemple d'application à déployer sur OpenShift :

Caractéristiques importantes

Arborescence recommandée pour l'archive ZIP

```
file_rouge-angular/
├─ docker/
│  ├─ frontend/Dockerfile
│  ├─ frontend/nginx.conf
│  └─ backend/Dockerfile
├─ k8s/
│  ├─ frontend-deployment.yaml
│  ├─ backend-deployment.yaml
│  └─ route-frontend.yaml
├─ db.json
├─ package.json
├─ src/  (votre code Angular)
└─ README.md
```

Prérequis

Étapes de build & push (exemple avec Docker)

1. Build et push de l'image `json-server` :

```bash
# depuis la racine du projet
docker build -f docker/backend/Dockerfile -t <REGISTRY>/json-server:latest .
docker push <REGISTRY>/json-server:latest
```

2. Build et push de l'image Frontend :

```bash
docker build -f docker/frontend/Dockerfile -t <REGISTRY>/frontend:latest .
docker push <REGISTRY>/frontend:latest
```

3. Adapter les manifests dans `k8s/` si besoin :

Déploiement sur OpenShift

```bash
# se connecter
oc login --server=https://api.cluster.example.com:6443 -u myuser

# créer un projet (si nécessaire)
oc new-project file-rouge

# appliquer les manifests
oc apply -f k8s/backend-deployment.yaml
oc apply -f k8s/frontend-deployment.yaml
oc apply -f k8s/route-frontend.yaml
```

Vérifications

Notes sécurité / OpenShift

utilisent `nginx-unprivileged` et l'utilisateur `node` pour respecter cette contrainte.

Personnalisation

# File Rouge — Déploiement OpenShift

Ce dépôt contient une application composée d'un front Angular et d'un backend léger (`json-server`) utilisée pour un rendu OpenShift.

Composants

- Frontend : build Angular, servi par `nginx-unprivileged` sur le port `8080`.
- Backend : `json-server` servant `db.json` sur le port `3000`.

Arborescence

```
file_rouge-angular/
├─ docker/
│  ├─ frontend/Dockerfile
│  ├─ frontend/nginx.conf
│  └─ backend/Dockerfile
├─ openshift/
│  ├─ frontend-buildconfig.yaml
│  ├─ frontend-deploymentconfig.yaml
│  ├─ frontend-imagestream.yaml
│  ├─ backend-buildconfig.yaml
│  ├─ backend-deploymentconfig.yaml
│  ├─ backend-imagestream.yaml
│  └─ services.yaml
├─ k8s/
│  └─ route-frontend.yaml
├─ docker/backend/db.json
├─ package.json
├─ src/  # code Angular
└─ README.md
```

Prérequis

- `oc` (OpenShift CLI) configuré et connecté au cluster
- Droits pour créer ImageStreams, BuildConfigs, DeploymentConfigs et Routes
- (Optionnel) `docker`/`podman` local si vous souhaitez builder/pusher hors OpenShift

Build & déploiement (OpenShift)

1. Basculer sur le projet

```bash
oc project youssef-projet
```

2. Appliquer manifests OpenShift

```bash
oc apply -f openshift/
oc apply -f k8s/route-frontend.yaml
```

3. Lancer les builds (envoi du contenu local)

```bash
oc start-build json-server --from-dir=. --follow
oc start-build frontend --from-dir=. --follow
```

4. Vérifier le déploiement

```bash
oc get builds
oc get pods -o wide
oc get svc
oc get route frontend-route -o jsonpath='{.spec.host}'
```

Tests rapides

```bash
curl -I http://$(oc get route frontend-route -o jsonpath='{.spec.host}')
curl http://$(oc get route frontend-route -o jsonpath='{.spec.host}')/users
```

Bonnes pratiques

- Ne copiez pas `node_modules` dans le contexte de build : utilisez `.dockerignore` pour exclure `node_modules` et `dist`.
- Gardez les images runtime non-root (`nginx-unprivileged`, `USER node` ou uid non-root).
- Pour production, préférez builder l'image en CI et utiliser un registre privé/centralisé.

Contact

Pour tout problème de déploiement, fournissez les commandes et sorties suivantes :

- `oc get builds` / `oc logs build/<build-name>`
- `oc get pods` / `oc describe pod <pod>` / `oc logs pod/<pod>`

  Ce projet a été généré à l'aide de [Angular CLI](https://github.com/angular/angular-cli) version 19.1.7.

## Serveur de développement

Pour démarrer un serveur de développement local, exécutez :

```bash
ng serve
```

Une fois le serveur démarré, ouvrez votre navigateur et accédez à `http://localhost:4200/`. L'application se rechargera automatiquement à chaque modification des fichiers sources.

## Génération de code

Angular CLI inclut des outils puissants de génération de code. Pour générer un nouveau composant, exécutez :

```bash
ng generate component nom-du-composant
```

Pour obtenir une liste complète des schémas disponibles (comme `components`, `directives` ou `pipes`), exécutez :

```bash
ng generate --help
```

## Construction

Pour construire le projet, exécutez :

```bash
ng build
```

Cela compilera votre projet et stockera les artefacts de construction dans le répertoire `dist/`. Par défaut, la construction en mode production optimise votre application pour la performance et la vitesse.

## Exécution des tests unitaires

Pour exécuter les tests unitaires avec le test runner [Karma](https://karma-runner.github.io), utilisez la commande suivante :

```bash
ng test
```

## Exécution des tests end-to-end

Pour les tests end-to-end (e2e), exécutez :

```bash
ng e2e
```

Angular CLI ne fournit pas de framework de test end-to-end par défaut. Vous pouvez choisir celui qui convient le mieux à vos besoins.

## Ressources supplémentaires

Pour plus d'informations sur l'utilisation de Angular CLI, y compris des références détaillées sur les commandes, visitez la page [Vue d'ensemble et référence des commandes Angular CLI](https://angular.dev/tools/cli).

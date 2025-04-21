# 🔐 DevSecOps CI/CD – Analyse & Déploiement sécurisé de l’application Techstart

Projet personnel réalisé autour d’une application volontairement vulnérable (Techstart/EasyBuggy), dans le but de construire un pipeline CI/CD sécurisé intégrant l’analyse statique, le scan des dépendances, les tests dynamiques et le déploiement automatisé sur Kubernetes.

---

## 🚀 Objectifs du projet

- Reproduire des vulnérabilités connues dans un environnement contrôlé
- Intégrer des outils de sécurité dans une chaîne CI/CD complète
- Automatiser le build, l’analyse, le scan, le push et le déploiement
- Déployer sur AWS via Jenkins, EC2, ECR et EKS

---

## 🛠️ Stack utilisée

| Catégorie         | Outils / Services                                                                 |
|-------------------|------------------------------------------------------------------------------------|
| CI/CD             | Jenkins (pipeline déclaratif) – hébergé sur EC2                                   |
| Sécurité          | SonarQube (SAST), Trivy, Snyk (SCA), OWASP ZAP (DAST en CLI sur EC2)              |
| Conteneurisation  | Docker, Amazon ECR                                                                |
| Orchestration     | Kubernetes (EKS)                                                                   |
| Infrastructure    | AWS EC2 (Jenkins, ZAP, Trivy), IAM, VPC                                            |
| IaC / Config      | Terraform, Helm                                                                    |

---

## 📦 Pipeline Jenkins

- ✅ **Build Maven**
- ✅ **Scan SAST** avec SonarQube
- ✅ **Scan SCA** avec Snyk & Trivy
- ✅ **DAST** avec OWASP ZAP (en headless sur EC2)
- ✅ **Push image Docker** vers Amazon ECR
- ✅ **Déploiement automatique** sur EKS
- ✅ **Scan post-deploy** et visualisation des résultats

---

## 📊 Résultat

Le pipeline s'exécute automatiquement à chaque build.  
Chaque étape est visible dans le Jenkins Stage View :

![stage-view](capture.png)

Des rapports de sécurité sont générés automatiquement et sauvegardés sur l’instance EC2.

---

## 🔗 Démo rapide

### Local :

```bash
mvn clean install
java -jar target/easybuggy.jar


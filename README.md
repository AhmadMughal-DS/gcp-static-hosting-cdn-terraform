# GCP Global Static Hosting + CDN (Terraform)

> A static website on Cloud Storage, served globally through Cloud CDN behind an HTTP Load Balancer — provisioned with Terraform.
> **Author:** Muhammad Ahmad · **IaC:** Terraform · **Cloud:** GCP

![Terraform CI](https://github.com/AhmadMughal-DS/gcp-static-hosting-cdn-terraform/actions/workflows/terraform.yml/badge.svg)
![Terraform](https://img.shields.io/badge/Terraform-1.6%2B-7B42BC?logo=terraform&logoColor=white)
![Security](https://img.shields.io/badge/scanned-tfsec%20%7C%20checkov-success)
![GCP](https://img.shields.io/badge/GCP-Cloud%20Storage%20%7C%20Cloud%20CDN%20%7C%20LB-4285F4?logo=googlecloud&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green)

---

## 📌 Overview

- A **Cloud Storage bucket** holds the site content (sample `index.html` / `404.html` uploaded by Terraform).
- A **backend bucket with Cloud CDN** caches content at Google's edge.
- A **global HTTP Load Balancer** (global IP → proxy → URL map → backend bucket) serves users worldwide.

## 🏗️ Architecture

> 🎨 **Interactive diagram (industry-standard icons):** [open in Lucid — page 25](https://lucid.app/lucidchart/3da75ce3-ea66-4296-81b3-00d20a60435b/edit)

```mermaid
flowchart LR
    User([Global User])
    LB[HTTP Load Balancer]
    CDN[Cloud CDN]
    GCS[(Cloud Storage Bucket)]

    User -->|HTTP| LB
    LB --> CDN
    CDN -->|origin| GCS
```

## 🚀 Deploy

```bash
cd terraform
gcloud auth application-default login
terraform init
terraform apply -var="project_id=YOUR_PROJECT_ID"

terraform output cdn_url
```

## 🧹 Clean up

```bash
terraform destroy -var="project_id=YOUR_PROJECT_ID"
```

## 💰 Cost note

Storage and CDN egress are cheap for a small site; the load balancer forwarding rule has a small hourly fee.

## 🔐 Production hardening (next steps)

- Add **HTTPS** with a Google-managed SSL certificate.
- Add a **custom domain** and Cloud DNS.
- Add **Cloud Armor** for edge security.

---

*Built and maintained by **Muhammad Ahmad**.*

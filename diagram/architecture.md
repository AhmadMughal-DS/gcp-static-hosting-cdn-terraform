# Architecture Diagram — GCP Static Hosting + CDN

## Lucid diagram

- **View:** https://lucid.app/lucidchart/2a50d855-ba8e-4b2d-9d7a-935d0d6008bd/view
- **Edit:** https://lucid.app/lucidchart/2a50d855-ba8e-4b2d-9d7a-935d0d6008bd/edit

## Lucid prompt (reusable)

```
Create a GCP architecture diagram titled "GCP Global Static Hosting + CDN".
A Global User sends HTTP traffic to an HTTP Load Balancer; the load balancer uses
Cloud CDN, which caches content from a Cloud Storage bucket origin. Label the arrows.
Clean, professional Google Cloud colors.
```

## Mermaid source

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

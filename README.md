# 🧠 Customer360 Platform — Data God Edition

## 🎯 Overview
Customer360 is a **real-time, AI-augmented data platform** built to unify customer data, events, and transactions across multiple source systems — enabling **360° analytics and personalization** at scale.

This project demonstrates **end-to-end data engineering mastery** using AWS, Snowflake, dbt, Airflow, and Terraform.

---

## ⚙️ Tech Stack

| Layer | Tools & Services |
|-------|------------------|
| **Ingestion** | AWS DMS, Kinesis, S3 |
| **Processing** | Glue, EMR (PySpark), Lambda |
| **Modeling** | dbt (SCD2 + testing) |
| **Storage** | Snowflake + S3 Data Lake |
| **Orchestration** | Airflow (local or MWAA) |
| **IaC / DevOps** | Terraform, GitHub Actions, CodePipeline |
| **AI Enrichment** | Bedrock / OpenSearch / pgvector |
| **Observability** | CloudWatch, Cost Explorer, DQ checks |

---

## 🧩 Project Phases

| Phase | Description | Status |
|--------|-------------|--------|
| 0 | [Environment Setup & Tool Installation](#p0) | ✅ Complete |
| 1 | Architecture Blueprint (Mermaid Diagram) | ⏳ | 
| 2 | Terraform Foundations (S3, IAM, Glue, Snowflake Stage) | ⏳ |
| 2.5 | Source Simulation (MySQL, Postgres, Kinesis, Batch) | ⏳ |
| 3 | Ingestion Pipelines (DMS → Kinesis → S3 → Glue) | ⏳ |
| 4 | Processing Layer (EMR / PySpark Jobs) | ⏳ |
| 5 | Modeling (dbt + SCD2 + Tests) | ⏳ |
| 6 | Orchestration (Airflow DAGs) | ⏳ |
| 7 | API Exposure (Lambda + API Gateway) | ⏳ |
| 8 | Observability (Metrics + Alerts) | ⏳ |
| 9 | Documentation & Cost Governance | ⏳ |
| 10 | AI Enrichment (Vector DB + Bedrock) | ⏳ |

---

## 🗂️ Repository Structure

<a name="p0"></a>
# ✅ Phase 0 — Environment Setup & Tool Installation (Completed)

## 🎯 Objective
Establish a fully functional local development environment for the **Customer360 (Data God Edition)** project — ready to build, deploy, and version-control AWS infrastructure and data engineering components.

---

## 🧠 Summary of Work Completed

### 🧩 System & Tool Setup
| Step | Tool | Status | Notes |
|------|------|--------|--------|
| 0.1 | **System Check** | ✅ | macOS ARM64 verified; Docker skipped for now |
| 0.2 | **Terraform CLI** | ✅ | Installed v1.13.4 via Homebrew |
| 0.3 | **AWS CLI + Profile (`c360`)** | ✅ | Configured and authenticated with `aws sts get-caller-identity` |
| 0.4 | **Python 3.9 + venv** | ✅ | Created environment `~/.venvs/c360`; core libs installed: boto3, awswrangler, faker, pyspark, pandas |
| 0.4.1–0.4.3 | **Project Scaffolding** | ✅ | Repo initialized with folders, `.gitignore`, and `README.md` |
| 0.4.4–0.4.6 | **Git & GitHub Setup** | ✅ | Repo pushed to `https://github.com/imihran/customer360.git` using HTTPS |
| 0.4.7 | **SSH Keys (Optional)** | ✅ | Skipped — HTTPS auth works via macOS Keychain |

---

## 🗂️ Folder Structure
```text
customer360/  
├── terraform/ — Terraform IaC modules  
├── src/ — Python ETL, Lambda, Glue scripts  
├── dbt/ — dbt models & tests  
├── airflow/ — DAGs & orchestration configs  
├── simulator/ — Synthetic data generators (MySQL, Kinesis)  
├── docs/ — Architecture diagrams & runbooks  
├── .gitignore  
└── README.md
```
---

## 🧩 Python Environment Summary
- Python 3.9.6  
- Virtual env: `~/.venvs/c360`  
- Installed libraries:
  - boto3  
  - awswrangler  
  - faker  
  - pyspark  
  - pandas  
- Verified with:  
  `python -c "import boto3, pyspark, pandas; print('✅ Python env ready')"`

---

## ✅ Phase 0 Outcome
A **production-ready local dev environment** with:
- AWS CLI + Terraform authentication  
- Python virtual env for Glue/EMR work  
- Git version control + GitHub repo  
- Organized project scaffolding and docs

---



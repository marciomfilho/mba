# Lab EKS com Terraform - Deploy NGINX

Este projeto provisiona um cluster EKS na AWS, cria Node Groups, deploy de namespace, aplicação nginx e Service LoadBalancer.  
Baseado no roteiro do [Lab-05/02 do GitHub](https://github.com/gersontpc/containers/blob/main/Lab-05/02-cluster-eks/README.md).

## Pré-requisitos

- AWS CLI configurado e credenciais válidas
- Terraform v1.0+
- Provider AWS e Provider Kubernetes habilitados
- Ter os IDs das subnets da VPC, ARN da LabRole e região correta

## Passo a passo

### 1. Clonar o projeto

git clone <repo-url> && cd <repo-folder>

text

### 2. Alterar variáveis no arquivo `variables.tf`

Edite os seguintes campos:
variable "lab_role_arn" { default = "arn:aws:iam::<SEU-ID-CONTA>:role/LabRole" }

variable "region" { default = "us-east-1" }

variable "subnet_ids" {
type = list(string)
default = [
"<subnet-1>",
"<subnet-2>",
"<subnet-3>"
]
}

text

Defina também o nome do cluster e do Node Group se desejar customizar.

### 3. Criar secrets para provider Kubernetes

O provider Kubernetes utiliza os dados do cluster gerado pelo Terraform, mas se necessário crie um secret com credenciais para acessar APIs privadas.

Exemplo de criação de secret:
resource "kubernetes_secret" "sample" {
metadata {
name = "aws-secret"
namespace = "default"
}
data = {
key = "valor"
secret = "valor_secreto"
}
}

text
(Adapte conforme sua necessidade real de secret – tokens para CI/CD, integração etc.)

### 4. Inicializar e aplicar Terraform

terraform init
terraform plan
terraform apply

text

### 5. Conferir o deploy

Após a aplicação:

- O cluster EKS será criado
- Node Group provisionado
- Namespace e deployment do nginx criados
- Service LoadBalancer exposto

Use o output `nginx_lb_hostname` para acessar a aplicação via navegador.

### 6. Customização extra

- Edite o campo `replicas` para escalar pods
- Altere o campo `image` para novos testes/versionamento
- Use o Console AWS para liberar a porta HTTP no Security Group dos Nodes

---

## Dicas

- Sempre revisite as variáveis antes de aplicar!
- O cluster EKS pode demorar vários minutos para provisionar.
- A aplicação nginx estará acessível pelo hostname gerado no output do Terraform.

---

## Limpeza
Seguir o passo a passo do Gerson

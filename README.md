# Case descomplica

## Overview
Documento com todas as etapas para criação do ambiente de infraestrutura para aplicação DescoShop.

> #### Obs:
Com o intuito de deixar a leitura e o processo de implantação mais dinâmico e fluido, este REAME.md contém uma serie de links (para as documentações oficiais) de possiveis termos técnicos que possam gerar dúvidas.  

As etapas do processo de implantação do ambiente são dividas em diretórios separados:
- eks/
- workloads/
- frontend/
- databases/

Cada diretório contém um arquivo **variables.tf** e **backend.tf** que precisam ser preenchidos de acordo com seu ambiente para a execução do terraform.

Além disso é importante que seu arquivo **~/.aws/credentials** esteja configurado com um [aws profile](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html) com as devidas permissões de criação de recursos na AWS.

## Requirements
- [terrform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
- [awscli](https://docs.aws.amazon.com/pt_br/cli/latest/userguide/getting-started-install.html)
- [helm](https://helm.sh/docs/intro/install/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)

## Directory summary
Descrição de cada diretório do projeto.
##### eks/
Contém os arquivos terraform necessários para a implantação do cluster EKS, incluíndo a sua devida VPC.

##### workloads/
Contém os arquivos terraform com as declarações de todos os [workloads](https://kubernetes.io/docs/reference/glossary/?fundamental=true#term-workloads) necessários para o ambiente do DescoShop:

| <center>Workload | <center>Função   |
| :---:   | :--------: |
| [ingress-nginx](https://github.com/kubernetes/ingress-nginx) | [Ingress Controller](https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/)   |
| [chartmuseum](https://chartmuseum.com/) | [Helm Repository](https://jfrog.com/devops-tools/article/helm-repository-best-practices/#:~:text=What%20is%20a%20Helm%20repository,is%20another%20advantage%20of%20Helm.)   |
| [kube-prometheus-stack](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack) | [Observability](https://www.ibm.com/topics/observability#:~:text=The%20term%20%E2%80%9Cobservability%E2%80%9D%20comes%20from,on%20feedback%20from%20the%20system.)   |
| [ArgoCD](https://argo-cd.readthedocs.io/en/stable/) | [GitOps](https://www.weave.works/technologies/gitops/)   |

Todos os workloads são instalados no cluster eks utilizando helm charts através do terraform com o [resource](https://developer.hashicorp.com/terraform/language/resources) [helm_release](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release).
Os [values files](https://helm.sh/docs/chart_template_guide/values_files/) de cada helm release estão definidos no diretório workloads/helm-values.

O diretório **workloads/manifests** abriga todos os [manifests](https://kubernetes.io/docs/reference/glossary/?all=true#term-manifest) necessários para configuração do [Image Updater](https://argocd-image-updater.readthedocs.io/en/stable/) do ArgoCD.


##### databases/
Contém os arquivos terraform necessários para criação da instancia RDS Postgress bem como sua respectiva VPC e Security Group.

##### frontend/
Diretório com os arquivos terraform para criação do frontend hospedado no bucket s3 privado utilizando o CloudFront para distribuir o conteúdo.


## Steps

#### Implantação do Cluster EKS

 - Acesse o diretório **eks/** e preencha todas as variables do arquivo variables.tf e o bloco de [backend](https://developer.hashicorp.com/terraform/language/settings/backends/configuration)  do arquivo backend.tf especificando o [profile](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html), [bucket](https://docs.aws.amazon.com/pt_br/AmazonS3/latest/userguide/UsingBucket.html) e [region](https://docs.aws.amazon.com/pt_br/AmazonRDS/latest/UserGuide/Concepts.RegionsAndAvailabilityZones.html).  

- Execute as seguintes instruções:
    ```
    terraform init
    terraform plan
    terraform apply
    ```

#### Instalação dos workloads no Cluster
 - Acesse o diretório workloads/ e preencha todas as variables do arquivo variables.tf e o bloco de backend do arquivo backend.tf especificando o profile, bucket e region.

 - Execute as seguintes instruções:
     ```
     terraform init
     terraform plan
     terraform apply
     ```

#### Implantação do database
- Acesse o diretório databases/ e preencha todas as variables do arquivo variables.tf e o bloco de backend do arquivo backend.tf especificando o profile, bucket e region.

- Execute as seguintes instruções:
    ```
    terraform init
    terraform plan
    terraform apply
    ```
#### Implantação do Frontend
- Acesse o diretório frontend/ e preencha todas as variables do arquivo variables.tf e o bloco de backend do arquivo backend.tf especificando o profile, bucket e region.

- Execute as seguintes instruções:
    ```
    terraform init
    terraform plan
    terraform apply
    ```

#### Peering Conection
Após a criação dos principais recursos, é imprescindível a configuração do [AWS Peering](https://docs.aws.amazon.com/vpc/latest/peering/what-is-vpc-peering.html) para que os microserviços do EKS se comuniquem com o RDS PostgresSQL.
A seguinte documentação descreve todo processo:

[Peering Configuration](https://docs.aws.amazon.com/pt_br/vpc/latest/peering/create-vpc-peering-connection.html)


#### Continuous Integration(CI)
Para fins demonstrativos a etapa de CI foi definida do projeto [goapp](https://github.com/GuhAlex/goapp) onde é utilizada uma esteira CI para buildar a aplicação golang e realizar o push da imagem no Image Registry da AWS ECR.

Antes de executar a esteira do GitActions é importante que repositorio goapp esteja criado no [ECR](https://docs.aws.amazon.com/pt_br/AmazonECR/latest/userguide/what-is-ecr.html) na AWS account utilizada.

 Além disso, as [GitActios secrets](https://docs.github.com/en/actions/security-guides/using-secrets-in-github-actions) ECR_ACCESS_KEY_ID e ECR_SECRET_ACCESS_KEY precisam estar definas de acordo com a [AWS AccessKey](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html) utilizada.

 #### Continuous Delivery(CD)
Toda de parte de Continuos Delivery será executada através do ArgoCD Image Updater , que irá checar novas atualizações das images no ECR e atualizar de forma automatica no Cluster EKS.

# Criando VM no Nutanix usando terraform #

## Pré-requisitos ##

- Terraform (>=1.3.1) instalado no computador que será usado para conectar ao nutanix.
- Git client instalado no computador que será usado com terraform.
- Credenciais de acesso com permissão para provisionar máquinas virtuais no nutanix.

### Como usar ###

1. Primeiramente baixe o projeto para o computador que possui o terraform instalado:

```
server# git clone https://gitlab.intranet.domain.com/servidores/linux/terraform-createvm.git
```

2. Deve-se criar duas variáveis de ambiente (TF_VAR_nutanix_username e TF_VAR_nutanix_password), que serão usadas pelo terraform para autenticar na API do nutanix:

### Usando windows: ###

- Variável do usuário:

Abra uma instância do powershell (Windows + R, digite powershell e tecle Enter), no powershell, digite:

```
PS C:\Users\usuario> [System.Environment]::SetEnvironmentVariable('TF_VAR_nutanix_username','seu_login@intranet.domain.com',[System.EnvironmentVariableTarget]::User)
```

- Variável da senha:

```
PS C:\Users\usuario> [System.Environment]::SetEnvironmentVariable('TF_VAR_nutanix_password','sua_senha',[System.EnvironmentVariableTarget]::User)
```

### Usando Linux: ###

- Variável do usuário:
```
host# export TF_VAR_nutanix_username=seu_login
```

- Variável da senha:
```
host# export TF_VAR_nutanix_password=seu_login
```

3. Clone esse projeto do gitlab:
```
host# git clone http://gitlab.intranet.domain.com/servidores/linux/terraform-createvm.git
```

4. Entre no diretório "nutanix" e edite o arquivo de variáveis chamado "terraform.tfvars", definindo os seguintes parâmetros conforme necessidade:

```
vms = {
  "vm1" = {
    name     = "tf-validacao-01"
    n_socket = 1
    n_vcpu   = 2
    s_memory = 2048
    s_disk   = 0
    network  = "desenv"
  }

  "vm2" = {
    name     = "tf-validacao-02"
    n_socket = 2
    n_vcpu   = 2
    s_memory = 1024
    s_disk   = 0
    network  = "homolog"
  }
}
```

<kbd>⌘ Leia os comentários no arquivo para maiores instruções.</kbd>

5. Após concluir a edição das variáveis, execute o comando abaixo para o terraform baixar os plugins necessários:
```
host# terraform init
```

6. Execute o comando abaixo para o terraform exibir o que será efeito:
```
host# terraform plan
```

7. Para finalizar e provisionar a máquina virtual, execute:

```
host# terraform apply
```
E digite "yes" para confirmar ou utilize -auto-approve com o comando acima.

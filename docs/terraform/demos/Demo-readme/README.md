
# TERRAFORM && GITHUB && AWS DEMO

In this demo we will cover all about how to automate terraform workspaces,
github repositories, and AWS resources using terraform cloud.

## Prerequsites

### Accounts

Make sure you have accounts on all needed platforms:

- **Github**: Make sure you have a Github account that you can create, clone...
  repositories. (eg. Create an SSH key pair and set it to your github account
  for auth.)
- **Terraform Cloud**: Make sure you have a Terraform Cloud account with an
  organization in it you can use it.
- **AWS**: Make sure you have an AWS account with enough permisions to create
  access tokens.

*Optionally*: You can have use a secrets manager like "Doppler" to manage your
secrets more easier.

#### Setting up a SSH key pair for Github

To set up a ssh key pair for your Github account you first need to create one on
your machine. You can do that by using this command below.

```bash
ssh-keygen
```

Press enter and you will be redirected on a key generator. It will ask you to
provide some a name, passprase...etc. For that moment it's important to name it
appropriate so you can find it easier and know for what is created lately. (eg.
"github_auth_machine_name" or something like that.)

**Note**: I suggest to store it somewhere you can reach it even your machine is
destroyed. (eg. Maybe some cloud application designed especially for that.)

After you created your key pair named suitable, you can now navigate to
`~/.ssh` directory and copy the public key (so the one with `named_by_you.pub`)
because obviously would be 2 key cuz it's a pair: private key (the one with no
extention) and public key (the one with .pub extention).

*Note*: You will need to copy the all content of the public key.

Once you have the content of public key into your clipboard, navigate on your
browser into your Github account ==> Go to Settings ==> On the access section
you will find `SSH and GPG keys` click on it ==> There you will find
`New SSH key` click on it ==> Give a `Title` of the ssh key like the name of
your machine, set the key type as `Authentication Key` (should be the default
you will find anyway) and paste the public key we copied in clipboard
earlier in the `Key` section. ==> Click on Add SSH key. Done! You are all set.
You can now use ssh protocol to perform actions on your github account.

*Note*: You may be asked by to provide some config options before make actions.
Like provideing your username and email to git, just follow the instruction
git will provide to you and you should be fine.

## Secrets

After you are all set up and have all the needed accounts mentioned earlier, we
will need to create some "secrets". We call them secrets because they contain
sensitive information like token with permision to add 10000$ resources on
your AWS account :)) . So you can agree with me that we need a safe place to
store them properly, like i mentioned earlier a secret manager. But for this
Demo you can use what you want to store them, like a .txt file :)), but i don't
recommand as we discussed already.

### Github Tokens

Here we will need to create a `Fine-grained token`. This token we will use to
give terraform access to our repositories lately.

So what we will need to do:

1. Go again into your Github account settings.
2. Go to `Developer Settings`
3. There you will find `Personal access tokens` sections, click on it.
4. Go to Fine-grained tokens
5. Click on generate new token
6. Give a name to your token.
7. Set an expriation date.
8. On `Repository access` section select `All Repositories`
9. On `Permissions` Section go to `Repository permissions` and change
  `Administration` to "Read and write"
10. Now you can click on `Generate Token` and you will be redirected on the
fine-grained tokens list with the new token you created discovered so you can
copy and store it safely.

*Note*: Copy that somewhere safely cuz we will need it later. Be aware that
the token you just created have access to delete all your github repositories.

### Terraform Cloud Tokens

So in order to be able to comunicate with Terraform Cloud we will also need
some authentication. We will use a so called `User Token` in that scope.

Steps to create a `User Token`:

1. Go to your Terraform Cloud account.
2. Click to your user profile picture && click on `account settings`
3. In the left pop-up screen you will see `Tokens` section, click on it.
4. Click on `Create an API token`
5. Give it a description and an expriration data.
6. Click on generate token.

After the token is created copy it into your clipboard and store it in a safe
place like you did with the github token earlier.

### AWS Tokens

So now we need to create an access token for AWS so that we can manage AWS
resources using Terraform.

*Note*: You will need to be a root user or a user with enough permissions to
create an access token. So be aware.

Steps to create AWS access token:

1. Login into AWS console with your user account.
2. Click over your username on top-right corner of aws console.
3. Go to `Securiy Credentials`
4. Find `Access keys` sections and click on `Create access key`.
5. Selecte the `Command Line Interface` use case, confirm this actions and
  press `Next`
6. Give a `Desctiption Tag Value` (like for what you will use it for example)
  and click `Create access key`.
7. You will be meet by `Access key` (which is the access key ID) and the actual
  `Secret access key` (which is the access key value). Copy both of them and
  store properly.

*Note*: You will need to know which one is the one you need in the feature so
be sure that you give them a name, that way you know where to find the one you
want.

## Terraform Automation

The goal of this chapter is that at the end of it, we will be able to manage
terraform `projects` and `workspaces` automated in terraform cloud by using
terraform itself. For that we will need to use "ALT-F4-LLC" modules posted on
Terraform Registry.

### Creating a Managed Repositry

First we will need to create a Github repository to store our terraform
automation script.

Steps to Create the repository:

1. To to your Github page and selecte `Repositories`
2. When the Repositories list appear go on the top-right green button `New` and
  click it.
3. Add a proper name to your repository.
4. Select `Add a README file`
5. And select a Terraform .gitignore tamplate.
6. Create Repository.

Steps to clone the repository:

1. In Github go to the previously created repository.
2. In the top-right you will see a green button `Code`, click it and a dropdown
  menu will open with `Clone` on top of it.
3. Press SSH and copy the URI provided by Github. (Should be something like
`git@github.com:your-username/your-repo-name`)
4. On your terminal, navigate to the place you want to store your local
repository.
5. Last step is to write the git clone command in your terminal:

```bash
git clone git@github.com:your-username/your-repo-name
```

  Just change the URI with the one that you copied earlier.

### Automation scripts for Terraform Cloud projects and workspaces

Now that we have the repo clone, we can go in it and put there some terraform
automation scripts.
As I metioned before we are going to use the terraform modules created by
"ALT-F4-LLC". That modules incorporates all necessary resources of Terraform
Cloud Provider that enable us to create, edit, delete projects and workspaces
as we want.

*Note*: First we will create create a `main.tf` file inside the repo we just created
and cloned.

After we have the `main.tf` we can add the terraform script that will help us
with creation of those projects and workspaces. They are acutally the modules
from "ALT-F4-LLC" that we talked about.

```hcl
module "project" {
  source = "ALT-F4-LLC/project/tfe"
  version = "0.5.0"
  
  description = "Example description of project"
  name = "project-name"
  organization_name = var.organization_name
}

module "workspace" {
  source = "ALT-F4-LLC/workspace/tfe"
  version = "0.8.0"

  description = "Example description of workspace"
  name = "workspace-name"
  execution_mode = local
  organization_name = var.organization_name
  project_id = each.value.project_id
  }
```

You will notice that inside those moduels we have variables used
(`organization_name = var.organization_name`). Well now we need to create them
as we use them.

In the same directory you created the `main.tf` file now create a `variables.tf`
file. And you guess that right, there we will declare all our variables. Below
we will declare our variables inside the `variables.tf`:

```hcl
variable "organization_name" {
  default = "your_organization_name" # Terraform Cloud organization name
  type = string
}
```

Here terraform downloads all the providers , modules and anything we are using
in our terraform scripts.

```bash
terraform validate
```

On validate part, terraform actually parse your code, so it will just tell you
from the syntax perspective if your terraform automation script are OK.

*Note* It will not tell you from API perspective. It does not interact with your
infrastructure.

Use those 2 commands and make sure it does not fail on you.

Now that we have all done we actually want to apply our infrastructure into the
Terraform Cloud. But,first of all we will need to plan the terraform changes we
want to apply.

```bash
terraform plan \
    -out "terraform.tfplan" \
    -var="TF_TOKEN_APP_TERRAFORM_IO=your-api-token" \
    -var="TFE_TOKEN=your-api-token"
```

*Note*: We are trying to reach the Terraform Cloud injecting the variables into
plan command. So all you need to change is to put your own terraform token we
got in the previous steps in this demo and instead of "your-api-token". YOU NEED
THE SAME TOKEN VALUE ONE THE BOTH VARIABLES. And please stick with the variables
nameing provided in the command above.

After your plan command is ok it should get you 2 resources to add.

Now what we want to do next is to acctually apply the plan that we created with
apply command.

```bash
terraform apply \
    "terraform.tfplan" \
    -var="TF_TOKEN_APP_TERRAFORM_IO=your-api-token" \
    -var="TFE_TOKEN=your-api-token"
```

*Note*: We are again injecting the terraform api token into terraform cli so do
the same we did for the plan part here.

After the apply is done you should see a new project with a new workspace on
your Terraform Cloud Ogranization.

### Migrating state to Terraform Cloud

When you will look insde the folder we put our Terraform code you will notice
that know we have some new file added by terraform. That because still have
the state local. And our goal is also to migrate the state from our local
machine to the cloud.

Why we want this? Lets say that you create some awesome complex infrastructure
you are proud of and you have the state of it local, and your machine gets
destroyed.

In order to achieve the migration to the cloud we will need to create a
`backend.tf` file. We are creating this file because we want to point our state
to the Terraform cloud.

So after you create the `backend.tf` file, go to your Terraform Cloud web app
and click on the brand new workspace we just created earlier. There you will find
an "Example code", copy the the content of the example code from there and paste
it into your `backend.tf` file.

Now that we have the `backend.tf` in place with the proper code in it, we need
to initialize again.

```bash
terraform init \
    -var="TF_TOKEN_APP_TERRAFORM_IO=your-api-token" \
    -var="TFE_TOKEN=your-api-token"
```

*Note*: We now passing the terraform api token to the init command because we
will migrate the state to cloud so we need credentials for this action.

After you insert your command into terminal and press enter you will be asked if
you want to migrate your existing state to Terraform Cloud. So you will type in
"yes". And after completion your state should be new in the cloud.

You can look now into your terraform.tfstate file and you will notice that is
empty.

Last think you can do is to remove the `terraform.tfstate`,`terraform.tfplan`
and `terraform.tfstate.backup` files as we don't need them anymore.

## Dynamic Configuration

So now we have a project and a workspace in our Terraform Cloud. But what if we
need another project, or another workspace? One option is to create another
module with another name for example:

```hcl
module "project" {
  source = "ALT-F4-LLC/project/tfe"
  version = "0.5.0"
  
  description = "Example description of project"
  name = "project-name"
  organization_name = var.organization_name
}

module "antoher_project" {
  source = "ALT-F4-LLC/project/tfe"
  version = "0.5.0"
  
  description = "Another example description of project"
  name = "another-project-name"
  organization_name = var.organization_name
}
```

And it the same story with workspaces.

But what if we need to 100 workspaces? Then will get a lil bit overwhelming
don't you think?

That why we will use terraform locals instead.

Besically instead of just copy&paste the modules and changeing names we will
iterate through a local map.

To achieve that we need to make some changes in `main.tf` file and also create
a new `locals.tf` file.

Lets start with `locals.tf`:

```hcl
locals {
  project = {
    "mkdocs-project" = {
      description = "Example description of project"
    }
  }
}
  workspace = {
    "mkdocs-tfe" = {
      description    = "Example description of project"
      execution_mode = "local"
      project_id     = module.project["mkdocs-project"].id
    }
  }
```

Now taht we have the locals that we can iterate through lets modify the
`main.tf` file we have.

```hcl
module "project" {
  for_each = local.project

  source = "ALT-F4-LLC/project/tfe"
  version = "0.5.0"
  
  description = each.value.description
  name = each.key
  organization_name = var.organization_name
}

module "workspace" {
  for_each = local.workspace

  source = "ALT-F4-LLC/workspace/tfe"
  version = "0.8.0"

  description = each.value.description
  name = each.key
  execution_mode = each.value.execution_mode
  organization_name = var.organization_name
  project_id = each.value.project_id
}
```

Before we init, validate, plan, and apply changes. We need to understand that
we did not create another project and workspace. At least we do not intend to do
so. We need to tell terraform that the actual already created terraform project
and workspace are de one that we try to interate through locals right now.

We can do this adding into the `main.tf` file the lines below:

```hcl
moved {
  from = module.project
  to = module.project[mkdocs-project]
}

moved {
  from = module.workspace
  to = module.workspace[mkdocs-tfe]
}
```

Last think we need to do is to change the `backed.tf` file to point on the right
workspace because above we just renamed our workspace.

*Note*: Go into your `backend.tf` file and change the workspace name with the
one we just created, in my case will be "mkdocs-tfe".

Ok in that moment you actually can init, validate, plan and apply injecting
terraform api token using -var as we did before.

*Note*: You don't have to use terraforn token to terraform validate. It's just
syntax check, it does not got to could or affect infra in any way.

You Shoud have now 1 change, renameing the workspace, apply it and lets go to
the next step. P.S: You can look to your changes on your Terraform Cloud.

Now that we have all set we need to push the changes into the github remote
repo.

*Note*: Add all now files except terraform.tfplan.

Now we have a SOURCE OF TRUTH.

## Version Control GITOPS

Now what we want to do is to connect terraform cloud to the repository we just
pushed previously. Why we want this? Because we want github to be the only
source of truth.

So shortly we want that every time we make a change into that github repository
the changes will apply also to the Terraform Cloud, that why we connect them
togheter.

To achieve this you need to go into your Terraform Cloud organization, go to
settings and down below you will find section "Version Control" ==> "Providers".

Click on "Add VCS Providers", Go to the Github section and selecte Github App.
Connect your account and authorize all repositories.

*Note*: It is possible that will appear as "Installed" if you connected to the
Terraform Cloud using SSO with Github.

Next we need to go into our Github account ==> Settings ==> Applications ==>
There you will find Terraform Cloud Application. You need to click on "Configure"
you will find next to Terraform Cloud Application.

*IMPORTANT*: You will need to COPY the CODE from the URL once you click on
"Configure".

That code will be the installation ID we will use in the next stepts, welcome to
DevOps`:))`.

Now that we have the installation ID(The CODE we just copied earlier) we can go
again to our files and add some things on the `variables.tf` file we created
earlier this course.

The `variables.tf` should look something like that:

```hcl
variable "organization_name" {
  default = "your_organization_name" # Terraform Cloud Organization Name
  type = string
}

variable "github_app_installation_id" {
  default = 31231231 # here you should add the installation ID we coiped
  type    = number
}

variable "github_organization_name" {
  default = "github-org-name" # This should be your github username
  type    = string
}
```

Now the next step is to use that `github_app_installation_id` to tell Terraform
Cloud which workspace have access to the installation between her and Github.

So we will need to create a new file called `data.tf` file that will look like
exactily like that:

```hcl
data "tfe_github_app_installation" "this" {
  installation_id = var.github_app_installation_id
}
```


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
- **AWS**: Make sure you have an AWS account with enough permissions to create
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
provide some a name, passphrase...etc. For that moment it's important to name it
appropriate so you can find it easier and know for what is created lately. (eg.
"github_auth_machine_name" or something like that.)

**Note**: I suggest to store it somewhere you can reach it even your machine is
destroyed. (eg. Maybe some cloud application designed especially for that.)

After you created your key pair named suitable, you can now navigate to
`~/.ssh` directory and copy the public key (so the one with `named_by_you.pub`)
because obviously would be 2 key cuz it's a pair: private key (the one with no
extension) and public key (the one with .pub extension).

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
Like providing your username and email to git, just follow the instruction
git will provide to you and you should be fine.

## Secrets

After you are all set up and have all the needed accounts mentioned earlier, we
will need to create some "secrets". We call them secrets because they contain
sensitive information like token with permission to add 10000$ resources on
your AWS account :)) . So you can agree with me that we need a safe place to
store them properly, like i mentioned earlier a secret manager. But for this
Demo you can use what you want to store them, like a .txt file :)), but i don't
recommend as we discussed already.

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
7. Set an expiration date.
8. On `Repository access` section select `All Repositories`
9. On `Permissions` Section go to `Repository permissions` and change
  `Administration` to "Read and write"
10. Now you can click on `Generate Token` and you will be redirected on the
fine-grained tokens list with the new token you created discovered so you can
copy and store it safely.

*Note*: Copy that somewhere safely cuz we will need it later. Be aware that
the token you just created have access to delete all your github repositories.

### Terraform Cloud Tokens

So in order to be able to communicate with Terraform Cloud we will also need
some authentication. We will use a so called `User Token` in that scope.

Steps to create a `User Token`:

1. Go to your Terraform Cloud account.
2. Click to your user profile picture && click on `account settings`
3. In the left pop-up screen you will see `Tokens` section, click on it.
4. Click on `Create an API token`
5. Give it a description and an expiration date.
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
5. Select the `Command Line Interface` use case, confirm this actions and
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

### Creating a Managed Repository

First we will need to create a Github repository to store our terraform
automation script.

Steps to Create the repository:

1. To to your Github page and select `Repositories`
2. When the Repositories list appear go on the top-right green button `New` and
  click it.
3. Add a proper name to your repository.
4. Select `Add a README file`
5. And select a Terraform .gitignore template.
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
As I mentioned before we are going to use the terraform modules created by
"ALT-F4-LLC". That modules incorporates all necessary resources of Terraform
Cloud Provider that enable us to create, edit, delete projects and workspaces
as we want.

*Note*: First we will create create a `main.tf` file inside the repo we just created
and cloned.

After we have the `main.tf` we can add the terraform script that will help us
with creation of those projects and workspaces. They are actually the modules
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

You will notice that inside those modules we have variables used
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
naming provided in the command above.

After your plan command is ok it should get you 2 resources to add.

Now what we want to do next is to actually apply the plan that we created with
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
your Terraform Cloud Organization.

### Migrating state to Terraform Cloud

When you will look inside the folder we put our Terraform code you will notice
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
an "Example code", copy the content of the example code from there and paste
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

Basically instead of just copy&paste the modules and changing names we will
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

Now that we have the locals that we can iterate through lets modify the
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
and workspace are de one that we try to iterate through locals right now.

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

*Note*: You don't have to use terraform token to terraform validate. It's just
syntax check, it does not got to could or affect infra in any way.

You should have now 1 change, renaming the workspace, apply it and lets go to
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
together.

To achieve this you need to go into your Terraform Cloud organization, go to
settings and down below you will find section "Version Control" ==> "Providers".

Click on "Add VCS Providers", Go to the Github section and select Github App.
Connect your account and authorize all repositories.

*Note*: It is possible that will appear as "Installed" if you connected to the
Terraform Cloud using SSO with Github.

Next we need to go into our Github account ==> Settings ==> Applications ==>
There you will find Terraform Cloud Application. You need to click on "Configure"
you will find next to Terraform Cloud Application.

*IMPORTANT*: You will need to COPY the CODE from the URL once you click on
"Configure".

That code will be the installation ID we will use in the next steps, welcome to
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
exactly like that:

```hcl
data "tfe_github_app_installation" "this" {
  installation_id = var.github_app_installation_id
}
```

Now we need to change the workspace module from `main.tf` file to have a
"vcs_repo" attribute. It will look like below:

```hcl
module "workspace" {
  for_each = local.workspace

  source = "ALT-F4-LLC/workspace/tfe"
  version = "0.8.0"

  description = each.value.description
  name = each.key
  execution_mode = each.value.execution_mode
  organization_name = var.organization_name
  project_id = each.value.project_id
  
  vcs_repo = {
    github_app_installation_id = data.tfe_github_app_installation.this.id
    identifier                 = each.value.vcs_repo_identifier
    }
}
```

You can notice that now we have a "vcs_repo_identifier" in module workspace ->
vcs repo attribute, which has its value from locals iteration, so we will need
to add this also into `locals.tf` file.

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
      execution_mode = "remote"
      project_id     = module.project["mkdocs-project"].id
      vcs_repo_identifier ="${var.github_organization_name}/repository-name"
    }
  }
```

The value of the vcs_repo_identifier will be your normally github username which
we already defined in "github_organization_name" variable (so we can use it),
followed by a slash `/` and the Github repository name.

*Note*: WE WILL ALSO CHANGE THE EXECUTION MODE FROM LOCAL TO REMOTE.

Now is the moment when you can do a terraform plan (using your terraform
credentials), and if you go to the Terraform Cloud Workspaces Overview you will
see a plan being executed on the cloud.

*Note*: WE need to let it finish and DO NOT APPLY, because it will just revert
the changes we've done,so after it's done discard it, why? Because we did not
push our changes to github(our ONLY source of truth).

But before we commit our changes to github we need to add into Terraform Cloud
some variables.

Go to Terraform cloud --> Settings --> Variable Sets.

Click on "Create Variable Set", give it a name , select apply to specific
projects and workspaces, go to apply to workspaces dropdown menu and select your
workspace.

Now we need to add the actual variable so go down and you will find
"add variable", select the variable category "environment variable". The key of
the variable will be "TFE_TOKEN" and the value will be the one used to do
terraform plan for example.

Now we can commit and push our changes into github and after it you can see that
a plan will be triggered in Terraform Cloud that will hopefully succeed.

## Github Automation

This chapter is basically using terraform and github to automate the creation of
of our github repositories.

For that we will need to create another repository `:))`. So go to your github
account and create another repository, you can follow the same steps we did
before but change the name as you wish(better something related to github).

Now that we have the new repository, go to the `local.tf` file we created on
the previous repository we created and add a new workspace for the newly created
repository.

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
      execution_mode = "remote"
      project_id     = module.project["mkdocs-project"].id
      vcs_repo_identifier ="${var.github_organization_name}/repository-name"
    }
  }

    "new-workspace-for-new-github-repo" = {
      description    = "Example description of workspace"
      execution_mode = "local"
      project_id     = module.project["mkdocs-project"].id
      vcs_repo_identifier = "${var.github_organization_name}/new-github-repo"
    }
```

*Note*: We are setting the execution mode to "local" because we don't actually
have a state for that workspace. So we set it like that first.

Now we just need to add the changes, commit and push to github and our workspace
will be created. Wait until plan is triggered after push and apply the changes.

Next think we need to do is to clone the repository we create for github
automation into our machine. So go on and do that.

Inside the repo we will create a `locals.tf` file, a `main.tf` and
`variables.tf` file. Let's start with `main.tf` file.

We will use again an "ALT-F4-LLC" module posted on Terraform Registry that is
designed to automate creation of github repositories.

So inside `main.tf` file we will have:

```hcl
module "repository" {
  for_each = local.repos

  source  = "ALT-F4-LLC/repository/github"
  version = "0.5.0"

  description        = each.value.description
  gitignore_template = each.value.gitignore_template
  name               = each.value.name
  owner              = var.owner
  topics             = each.value.topics
  visibility         = each.value.visibility
}
```

Yeah, we will use locals to iterate through each key, value again. So let's
create `locals.tf` file:

```hcl
locals {
  repos = {
    "fisrt-repo" = {
      description        = ""
      gitignore_template = "Terraform"
      name               = "fisrt-repo"
      topics             = ["mkdocs", "terraform"]
      visibility         = "public"
    }

    "second-repo" = {
      description        = ""
      gitignore_template = "Terraform"
      name               = "second-repo"
      topics             = ["mkdocs", "terraform"]
      visibility         = "public"
    }
  }
}
```

*Note* The key of the map and the value of the name will be the name of the
repos we created till now, so "first-repo" will be the name of the first-repo
we created on the course with terraform automation and the second-repo name
will be the one we created for repository automation in this section.

Now we will need the `variables.tf` because we have a variable used in the
repository module called "owner", so let's create it.

`variables.tf` file will look something like that:

```hcl
variable "owner" {
  default = "you-username" # this will be your github username
  type    = string
}
```

You can go make a terraform init and validate to check if everything is fine.

If all it's ok we can create a `backend.tf` file to point on our new workspace.
The file will look something like that:

```hcl
terraform {
  cloud {
    organization = "terraform-organization-name"

    workspaces {
      name = "last-create-workspace-name"
    }
  }
}
```

Now you can make a terraform init and plan with terraform credentials as -var,
to see what it's creates. You will notice that it will want to create the repos
that we already have created. So the solution for that is to import them into
our actual state.

We can do that by using the next terraform commands:

```bash
terraform import 'module.repository["second-repo-name"]github_repository.self'\
 'second-repo-name' \-var="TF_TOKEN_APP_TERRAFORM_IO=your-api-token"\
    -var="TFE_TOKEN=your-api-token"

terraform import 'module.repository["first-repo-name"].github_repository.self'\
 'first-repo-name'     -var="TF_TOKEN_APP_TERRAFORM_IO=your-api-token"\
    -var="TFE_TOKEN=your-api-token"
```

*Note*: Change with your own repo names in that order. And use your own tokens.

So now if you will do a plan and apply will take in consideration the repos that
we already have created.

In order to make it fully automated we will need to push our changes into github
for the github automation part. So go ahead and do that.

Next step in to go into Terraform Cloud and set again a variables set like we
did before.

This time we need to go attach the variable set to the most new workspace we
created for github automation so be aware to select that workspace.

We will have 2 ENVIRONMENT VARIABLES:
1.**GITHUB_TOKEN**: At the start of the course we made a fine-grained token.
  Key will be the "GITHUB_TOKEN" and value will be your fine-grained token.
2.**GITHUB_OWNER**: This will be your Github username.

Now we got into the terraform automation repository and change workspace
execution mode from `locals.tf`:

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
      execution_mode = "remote"
      project_id     = module.project["mkdocs-project"].id
      vcs_repo_identifier ="${var.github_organization_name}/repository-name"
    }
  }

    "new-workspace-for-new-github-repo" = {
      description    = "Example description of workspace"
      execution_mode = "remote" # this needs to be remote
      project_id     = module.project["mkdocs-project"].id
      vcs_repo_identifier = "${var.github_organization_name}/new-github-repo"
    }
```

Add, commit and push changes and now you should have a fully automated github
repository creation.

*NOTE*: You may need uncheck "Do not allow bypassing the above settings" from
branches protection github branches. OR you can create a new branch an merge it
into to apply your changes.

## AWS Automation

The scope of this chapter is to automate the creation of some AWS resources like
S3 Buckets, CloudFront and Lambda Egde.

First we need to create a repository for those Amazon resources. So go into your
Github Automation repository and add another repo on `locals.tf` file.

Should look somethinng like that:

```hcl
locals {
  repos = {
    "fisrt-repo" = {
      description        = ""
      gitignore_template = "Terraform"
      name               = "fisrt-repo"
      topics             = ["mkdocs", "terraform"]
      visibility         = "public"
    }

    "second-repo" = {
      description        = ""
      gitignore_template = "Terraform"
      name               = "second-repo"
      topics             = ["mkdocs", "terraform"]
      visibility         = "public"
    }
  }

    "third-repo" = {
      description        = ""
      gitignore_template = "Terraform"
      name               = "third-repo"
      topics             = ["mkdocs", "terraform"]
      visibility         = "public"
    }
  }
```

Create a new branch, commit your changes to that branch and push. You now can go
an create a pull request on github, see if the plan is ok. Now you can merge the
new branch into main, wait the plan again and apply the plan. Now you will have
a new repository in your github account.

After you do this you clone the newly created repo on your machine.

Now we need to add some terraform modules into that repository that allow us to
create AWS resources(S3-bucket, Cloudfront and Lambda Edge). In order to do that
I will provide a link below with a repository where you will find exactly all
files you need to have in that repository to be able to create those resources.
This link we are talking about you will find below:

*IMPORTANT*: <https://github.com/Digital-Anthropic/terraform-aws-cloudfront>

After you have into your repository all those files existent in the link
provided you can go and create again a new branch, commit your changes, push to
github, create a pull request, see if all it's ok and merge.

Now that you have all required files into your github remote repository, we need
to add a workspace for that repository.

Go the terraform automation repository and there we need to change 2 files:
`main.tf` and "locals.tf", lets start with `locals.tf`:

"""hcl
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
      execution_mode = "remote"
      project_id     = module.project["mkdocs-project"].id
      vcs_repo_identifier ="${var.github_organization_name}/repository-name"
    }
  }
    "new-workspace-for-new-github-repo" = {
      description    = "Example description of workspace"
      execution_mode = "remote" # this needs to be remote
      project_id     = module.project["mkdocs-project"].id
      vcs_repo_identifier = "${var.github_organization_name}/new-github-repo"
    }
    "aws-repo-workspace" = {
      description    = "Example description of workspace"
      execution_mode = "remote"
      project_id     = module.project["mkdocs-project"].id
      vcs_repo_identifier = "${var.github_organization_name}/aws-repo-name"
      variables = [
        {
          caterogy = "terraform"
          key = "bucket_name"
          value = "mkdocs-bucket"
        },
        {
          caterogy = "terraform"
          key = "cloudfront_price_class"
          value = "PriceClass_100"
        },
      ]
    }
"""

*Note*: We added the new workspace with the repo identifier pointing to the
newly create repo we add our aws modules. Also you will notice that we now have
some variables on that workspace, that because we can specify the variables we
need in the workspace.

Now we need to change the `main.tf`:

```hcl
module "workspace" {
  for_each = local.workspace

  source = "ALT-F4-LLC/workspace/tfe"
  version = "0.8.0"

  description = each.value.description
  name = each.key
  execution_mode = each.value.execution_mode
  organization_name = var.organization_name
  project_id = each.value.project_id
  
  vcs_repo = {
    github_app_installation_id = data.tfe_github_app_installation.this.id
    identifier                 = each.value.vcs_repo_identifier
    variables                  = try(each.value.variables, [])
    }
}
```

We only changed the workspace module vcs_repo parameter, actually just added
`variables= try(each.value.variables, [])`.

After you have it all add the files changed to git, commit and push to the new
branch, make a pull request, make sure the plan it's ok and merge the branch.

*Note* After you merge the branch let it plan but do not apply.

First we need to add the environment variables for the AWS we obtained first on
the course. So now go to the Terraform Cloud settings again and add a new set of
variables.

As we did before add a name BUT NOW WE DON'T HAVE THE WORKSPACE TO ATTACH IT ON,
that because we did not created yet. SO just create the variables set and do not
attach them to a workspace.

ENVIRONMENT Variables:

1. AWS_ACCESS_KEY_ID = "THE ID OF THE AWS ACCESS KEY WE CREATED" SENSITIVE
2. AWS_DEFAULT_REGION ="eu_east_1" NOT SENSITIVE
3. AWS_SECRET_ACCESS_KEY = "THE VALUE OF THE ACCESS KEY" SENSITIVE

After you created those variables you can go apply your plan. AND after the plan
is fully applied you now can go to those variable sets you created and attach to
the newly created workspace.

Now you should have a plan that will auto create the resources to the amazon. If
will fail just try plan and apply again manually from the Terraform Cloud web
app.

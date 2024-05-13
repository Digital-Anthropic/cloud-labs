
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
you will find `SSH and GPG keys` clic on it ==> There you will find
`New SSH key` clic on it ==> Give a `Title` of the ssh key like the name of
your machine, set the key type as `Authentication Key` (should be the default
you will find anyway) and paste the public key we copied in clipboard
earlier in the `Key` section. ==> Clic on Add SSH key. Done! You are all set.
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
3. There you will find `Personal access tokens` sections, clic on it.
4. Go to Fine-grained tokens
5. Clic on generate new token
6. Give a name to your token.
7. Set an expriation date.
8. On `Repository access` section select `All Repositories`
9. On `Permissions` Section go to `Repository permissions` and change
  `Administration` to "Read and write"
10. Now you can clic on `Generate Token` and you will be redirected on the
fine-grained tokens list with the new token you created discovered so you can
copy and store it safely.

*Note*: Copy that somewhere safely cuz we will need it later. Be aware that
the token you just created have access to delete all your github repositories.

### Terraform Cloud Tokens

So in order to be able to comunicate with Terraform Cloud we will also need
some authentication. We will use a so called `User Token` in that scope.

Steps to create a `User Token`:

1. Go to your Terraform Cloud account.
2. Clic to your user profile picture && clic on `account settings`
3. In the left pop-up screen you will see `Tokens` section, clic on it.
4. Clic on `Create an API token` 
5. Give it a description and an expriration data.
6. Clic on generate token.

After the token is created copy it into your clipboard and store it in a safe
place like you did with the github token earlier.

### AWS Tokens

So now we need to create an access token for AWS so that we can manage AWS
resources using Terraform. 

*Note*: You will need to be a root user or a user with enough permissions to
create an access token. So be aware.

Steps to create AWS access token:

1. Login into AWS console with your user account.
2. Clic over your username on top-right corner of aws console.
3. Go to `Securiy Credentials`
4. Find `Access keys` sections and clic on `Create access key`.
5. Selecte the `Command Line Interface` use case, confirm this actions and
  press `Next`
6. Give a `Desctiption Tag Value` (like for what you will use it for example)
  and clic `Create access key`.
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

First we will need to create a Github repository to store our terraform
automation script.

Steps to Create the repository:

1. To to your Github page and selecte `Repositories`
2. When the Repositories list appear go on the top-right green button `New` and
  clic it.
3. Add a proper name to your repository.
4. Select `Add a README file`
5. And select a Terraform .gitignore tamplate.
6. Create Repository.

Steps to clone the repository:

1. In Github go to the previously created repository.
2. In the top-right you will see a green button `Code`, clic it and a dropdown
  menu will open with `Clone` on top of it.
3. Press SSH and copy the URI provided by Github. (Should be something like
git@github.com:your-username/your-repo-name)
4. On your terminal, navigate to the place you want to store your local
repository.
5. Last step is to write the git clone command in your terminal:

```bash
git clone git@github.com:your-username/your-repo-name
```
  Just change the URI with the one that you copied earlier.


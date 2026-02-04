Video Demonstration: I have recorded a dedicated video with audio explanation demonstrating the full process, including the creation of AWS resources and the live startup of the Strapi application. Watch here: https://www.loom.com/share/1fbf201247884a0b81fd671e19cbd0fd

1. Terraform Infrastructure & Automation

Full Provisioning: Wrote custom Terraform code to provision the entire AWS environment, including the VPC, Subnets, and Internet Gateway.

Security Groups: Manually configured Security Groups to allow traffic on ports 22 (SSH), 80 (HTTP), and 1337 (Strapi).

SSH Key Automation: Used the tls_private_key resource to automatically generate an SSH key pair and save the .pem file locally for secure access.

2. Strapi Installation & Deployment

Installation: Followed official documentation to install Node.js and Strapi on the Ubuntu EC2 instance.

Commands Used:

Created the app: npx create-strapi-app@latest my-strapi-project

Built the admin panel: npm run build

Started the server (Production): pm2 start npm --name "strapi" -- run start

3. Version Control (GitHub)

Repository Management: Initialized Git inside the EC2 instance and handled .gitignore to exclude heavy node_modules.

Authentication: Solved authentication challenges using Personal Access Tokens (PAT).

Commands Used:

git remote add origin <repo_url>

git push -u origin main --force

4. Successful Deployment

Live Proof: The video confirms that all resources were successfully created and the Strapi application is running and accessible via the EC2 public IP.

# aws-cloud-architect

http://52.88.217.123/


# Cloud Architecture - Customer Recommendation

Customer: Home Depot

Prepared by Kevin Glover, Solutions Architect, AWS

Home Depot's tagline is 'More saving. More doing'. Moving their data center-centric architecture to AWS positions the home improvement supplier for exactly that - more saving, and more doing. This recommendation outlines a scalable, elastic, redundant cloud architecture for Home Depot's e-commerce platform that positions the retailer for organic growth.

### Architecture

![alt text](https://www.lucidchart.com/publicSegments/view/670300fb-a10d-4d4e-925e-d2aaf9b5aa89/image.jpeg)

### Assumptions
- Proposal delivers a cloud-based architecture for Home Depot's consumer-facing, e-commerce platform
- Customer has allocated appropriate funding for a direct connect
- Organization operates in North America
- Customer has no existing disaster recovery plan
- Customer is using MySQL database on premise

## Well-Architected Design Principles:
- ### Operational Excellence
    - Defining infrastructure as code (IaC) is a cornerstone to scaling cloud-based workloads. It eliminates manual infrastructure management and allows rapid, iterative improvements that can be easily audited and, in the face of quality issues, rolled back. We recommend CloudFormation to accomplish this, but a tool like Terraform will meet this need too.
     - Managed services are another building block of scalable applications. With AWS, these services include RDS (managed relational database), S3, CloudFront and Route53. We've incorporated each into the architecture. These services remove the operational overhead and free Home Depot's TechOps teams to focus on adding business value like developing the application or creating a better user experience through infrastructure.
     - Monitoring is the backbone of any DR solution. For our automated DR solution on AWS, we suggest CloudWatch. When application alarms fire, these notifications will be events that trigger action and follow up in Home Depot's web application infrastructure.
     - The architecture is designed with load-balancers between all application layers it supports. These include requests to the compute stacks from users and from the compute stack to the database layer. This allows seamless horizontal scaling and limits downtime to different tiers of the application if one piece falls.
- ### Security
     - Data migration will be securely handled using encryption in transit and at rest. Our dedicated network direct connect pipe will ferry data directly into AWS, ensuring we are not traversing the internet and limiting all traffic to our secure network with AWS.
     - Data migration is another essential aspect of security. In the reference architecture, we recommended the storage gateway service that allows efficient bi-directional file transfer. Server-side encryption should be enabled and all data will traverse the direct connect for a secure network connection.
     - Finally, this design is optimized for least privilege network access in all layers of the application. Only allowing HTTP on ports 80 & 443 to the public subnets via the application load-balancer, security groups and NACLs. This also restricts access to the private subnets by ports and protocols needed for databases to talk to the compute stack, using the same stateful and stateless networking tools.
- ### Reliability
     - For web application compute stack, we recommend containerization and AWS elastic container service (ECS). ECS clusters employ AWS features such as auto-scaling groups which allow the application to scale horizontally based on defined metrics like network latency or instance operating system utilization (CPU or memory).
     - To migrate the customer's database to AWS, we recommend using the Database Migration Service. The service allows the source database to remain operational, which minimizes downtime during the cut over.
"	Performance Efficiency
     - In our referenced architecture, we recommend using a caching cluster for frequently accessed data. For Home Depot's web application, a caching service will manage user web sessions like their shopping carts and reduces latency by offloading frequent database query requests.
     - Using a caching service also allows for bulk updates of customer information by storing our most frequent users in cache.
- ### Cost Optimization
     - Container technologies and ECS can help reduce cost while operating Home Depot's infrastructure on the AWS cloud. Containers allow us to densely pack the containers on EC2 instances to maximize the performance of our compute layer. With ECS service definitions we can define massive container expansion to scale quickly while optimizing cost savings with service definitions that reduce containers in response to lower demand. Reducing containers in the cluster can also mitigate EC2 compute nodes in the ECS cluster. This horizontal scaling is made capable by AWS CloudWatch service, and monitors our resources so we can build self-healing and cost-effective infrastructure.
    - Another significant cost saver comes in the realm of data storage. Using S3 for data storage can maximize savings by applying lifecycle policies to our buckets. Lifecycle policies allow us to migrate data to different S3 services (i.e. glacier, our archival storage solution) or reduce redundancy storage for objects that don't need nine 9's of durability.

The following architecture design allows for a scalable, reliable infrastructure for Home Depot's upcoming Marketing campaign but also provides a scalable, elastic, redundant foundation to that enables continuous improvement and continuous iteration for their customers - now and in the future.

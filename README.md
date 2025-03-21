# Application for load simulation of MySQL, Postgres, MongoDB databases.

Application for **MySQL**, **PostgreSQL**, and **MongoDB** database load simulation with user-friendly web interface in browser and detailed database monitoring. 

* A user-friendly web interface is used for load management. You can control the number of concurrent connections and the complexity of queries. 

* The algorithms, SQL, and NoSQL database queries are the same for all databases, allowing them to be compared in similar usage scenarios.

* The load simulation uses a dataset with GitHub data about repositories and Pull Requests in JSON format. The data can be uploaded from your organization's GitHub via API or used as a test dataset in CSV format. 

* The application lets you connect to databases in any environment or cloud. 


This demo application showcases the usage of **MySQL**, **PostgreSQL**, and **MongoDB** databases, along with database monitoring and deployment in **Kubernetes** environments. It provides an opportunity to explore how these databases can be tested and monitored using Go applications and [Percona Monitoring and Management](https://docs.percona.com/percona-monitoring-and-management/index.html) (PMM) tools.


![Demo Control Panel](./assets/readme-contol-panel.png)

## Overview

The application consists of three main components:

1. **Control Panel**: A web-based application for managing database load and configurations.

2. **Dataset Loader**: A Go application fetches data from GitHub via API and loads it into the databases for testing and load simulation.

3. **Load Generator**: A Go application that generates SQL and NoSQL queries based on control panel settings.

### Usage Scenario:

1. Start the **Control Panel** in your browser (e.g., iPad).
2. Open **PMM** in the browser (e.g., screen or laptop).
4. Connect the databases in the **Control Panel Settings**. If you don't have databases, run them using Docker, DBaaS, or in a Kubernetes cluster using Percona Operators or Percona Everest.
5. Adjust the load on the **Control Panel** and monitor the changes in PMM.

The application connects to and generates load on MySQL, PostgreSQL, and MongoDB databases in the cloud or Kubernetes. You can start the databases with:

1. Docker and **[Docker Compose](https://docs.docker.com/compose/)**: Configuration is available in the repository.
2. **[Percona Everest](https://docs.percona.com/everest/index.html) or [Percona Operators](https://docs.percona.com/percona-operators) in Kubernetes**: If the databases are not externally accessible, run the application in the same cluster.
3. Any other installation method or connection to an existing database. 

## Running locally with Docker Compose

1. Clone the project repository:

   ```bash
   git clone https://github.com/dbazhenov/github-stat.git
   ```

   Open the folder with the repository `cd github-stat/`

2. Run the environment. Two options:

- Demo application only. Suitable for connecting to your own databases e.g. created with Percona Everest, Pecona Operators or other databases in the cloud or locally.

   ```bash
   docker compose up -d
   ```

- Demo application with test databases (MySQL 8.4, MongoDB 8, Postgres 17) and Percona Monitoring and Management (PMM).

   ```bash
   docker-compose -p demo-app -f docker/full.yaml up -d
   ```

   > **Note:** We recommend looking at the docker-compose files so you can know which containers are running and with what settings. You can always change the settings.

   > **Note:** PMM server will be available at `https://localhost`, access `admin` / `admin` . At the first startup, it will offer to change the password, skip it or set the same password (admin). 

3. Launch the Control Panel at `localhost:3000` in your browser.

4. Open the Settings tab and create connections to the databases you want to load.

   ![Demo App Dark Mode](./assets/demo-app.png)

   If you run the databases using `docker-compose-full.yaml`, you can use the following parameters to connect them

   - **MySQL**: `root:password@tcp(mysql:3306)/dataset`

   - **Postgres**: `user=postgres password='password' dbname=dataset host=postgres port=5432 sslmode=disable`

   - **MongoDB**: `mongodb://databaseAdmin:password@mongodb:27017/`

   If you connect to your databases, you probably know the settings to connect, if not, write to us.

5. In the **Settings** tab, load the test dataset for each database by clicking `Create Schema` and `Import Dataset` buttons. A small dataset from a CSV file (26 repos and 4600 PRs) will be imported by default.

   ![Settings MySQL Example](./assets/settings-mysql-example.png)

   > **Note:** To import a large complete dataset, add the [GitHub API token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens#creating-a-personal-access-token-classic) to the `GITHUB_TOKEN` environment variable and set `DATASET_LOAD_TYPE=githbub` in the `docker-compose.yaml` file for the `demo_app_dataset` service. Run `docker-compose up -d` when changing environment variables.

6. Turn on the `Enable Load` setting option and click Update connection to make the database appear on the `Load Generator Control Panel` tab. 

7. Open PMM 3 to see the connected databases and load. `https://localhost` (admin/admin). We recommend opening the Databases Overview dashboard in the Experimental section.

   ![PMM Databases Overview](./assets/pmm-overview.jpg)

   ![PMM Postgres](./assets/pmm-pg.jpg)

8. You can play with the load by including different types of SQL and NoSQL queries with switches, as well as changing the number of concurrent connections with a slider. 

   > **Note:** You can see the queries running in the QAN section of PMM, and you can also see the source code in the internal/load files for each database type.

### Additional databases 

The application can work with other compatible databases such as YugabyteDB, FerretDB or MariaDB

To start the databases use docker-compose files from the docker folder or instructions from official sites.

Start the application if it is not already running
```bash
docker-compose -p demo-app -f docker/app.yaml up -d
```

**YugabyteDB**

Run docker compose with the YugabyteDB database

```bash
docker-compose -p demo-app -f docker/yugabytedb.yaml up -d
```

Open the Settings tab in the Control Panel and create a connection

```user=yugabyte password='password' dbname=dataset host=yugabytedb port=5433 sslmode=disable``` 

YugabyteDB UI is on port 15433

**FerretDB**

Run docker compose with the FerretDB database

```bash
docker-compose -p demo-app -f docker/ferretdb.yaml up -d
```

Open the Settings tab in the Control Panel and create a connection
```
mongodb://username:password@ferretdb/ferretdb?authMechanism=PLAIN
```

**MariaDB**

Run docker compose with the MariaDB database

```bash
docker-compose -p demo-app -f docker/mariadb.yaml up -d
```

Open the Settings tab in the Control Panel and create a connection

```root:password@tcp(mariadb:3306)/dataset```

## Launching in Kubernetes

1. Create a Kubernetes cluster (e.g., Minikube or GKE). For GKE:

   ```bash
   gcloud container clusters create demo-app --project percona-product --zone us-central1-a --cluster-version 1.30 --machine-type n1-standard-16 --num-nodes=1
   ```

2. Install **Percona Everest** or **Percona Operators** in the Kubernetes cluster to create databases.
   Percona Everest documentation:

   - [Install Everest CLI](https://github.com/edithturn/github-stat/tree/main#:~:text=Percona%20Everest%20documentation%3A-,Install%20Everest%20CLI,-Install%20Everest)
   - [Install Everest](https://github.com/edithturn/github-stat/tree/main#:~:text=Install%20Everest%20CLI-,Install%20Everest,-Create%20databases%20if)

   Create databases if you don't have any.

3. Install PMM using Helm:

   ```bash
   helm repo add percona https://percona.github.io/percona-helm-charts/

   helm install pmm -n demo \
   --set service.type="LoadBalancer" \
   --set pmmResources.limits.memory="4Gi" \
   --set pmmResources.limits.cpu="2" \
   percona/pmm
   ```

4. Get the PMM administrator password:

   ```bash
   kubectl get secret pmm-secret -n demo -o jsonpath='{.data.PMM_ADMIN_PASSWORD}' | base64 --decode
   ```

5. Get a public IP for PMM:

   ```bash
   kubectl get svc -n demo monitoring-service -o jsonpath="{.status.loadBalancer.ingress[0].ip}"
   ```

6. Run the Demo application using HELM or manually, instructions below.

### Running the Demo Application Using Helm

1. Set the HELM parameters in the `./k8s/helm/values.yaml` file:

2. Launch the application:

   ```bash
   helm install demo-app ./k8s/helm -n demo --create-namespace
   ```

3. Get the public IP of the demo app and launch the control panel in your browser.
   Run this command to get the Public IP

   ```bash
   kubectl -n demo get svc
   ```

4. Open the Settings tab on the control panel and set the parameters for connecting to the databases you created in Percona Everest or with Percona Operators.

5. You may need to restart the dataset pod to speed up the process of loading the dataset into the databases.

   ```bash
   kubectl -n demo delete pod [DATASET_POD]
   ```

6. You can change the allocated resources or the number of replicas by editing the `values.yaml` file and issuing the command

   ```bash
   helm upgrade demo-app ./k8s/helm -n demo
   ```

   Demo App HELM parameters (./k8s/helm/values.yaml):

- `githubToken` - is required to properly load the dataset from the GitHub API. You can create a personal Token at [https://github.com/settings/tokens](https://github.com/settings/tokens).

- `separateLoads` - If true, separate pods for each database will be started for the load.

- `useResourceLimits` - if true, resource limits will be set for the resource consumption

- `controlPanelService.type` - LoadBalancer for the public address of the dashboard. NodePort for developing locally.

### Running Demo Application Manually

1. Create the necessary Secrets and ConfigMap:

   ```bash
   kubectl apply -f k8s/manual/config.yaml -n demo
   ```

   Check the k8s/config.yaml file. Be sure to set `GITHUB_TOKEN`, which is required to properly load the dataset from the GitHub API. You can create a personal Token at [https://github.com/settings/tokens](https://github.com/settings/tokens).

2. Run Valkey database:

   ```bash
   kubectl apply -f k8s/manual/valkey.yaml -n demo
   ```

3. Deploy the Control Panel:

   ```bash
   kubectl apply -f k8s/manual/web-deployment.yaml -n demo
   ```

4. Run `kubectl -n demo get svc` to get the public IP. Launch the control panel in your browser.

5. Open the control panel in your browser. Open the Settings tab. Set the connection string to the databases created in Percona Everest. Click the Connect button.

The first time you connect to MySQL and Postgres, you will need to create a schema and tables. You will see the buttons on the Settings tab.

6. Deploy the Dataset Loader:

   ```bash
   kubectl apply -f k8s/manual/dataset-deployment.yaml -n demo
   ```

5. Deploy the Load Generator:

   ```bash
   kubectl apply -f k8s/manual/load-deployment.yaml -n demo
   ```

8. For separate database load generators, apply these commands:

   - MySQL:

   ```bash
    kubectl apply -f k8s/manual/load-mysql-deployment.yaml -n demo
   ```

   - Postgres:

   ```bash
   kubectl apply -f k8s/manual/load-postgres-deployment.yaml -n demo
   ```

   - MongoDB:

   ```bash
   kubectl apply -f k8s/manual/load-mongodb-deployment.yaml -n demo
   ```

   You can set the environment variable to determine which database the script will load.

6. Control the load in the control panel. Change queries using the switches. Track the result on PMM dashboards. Scale or change database parameters with Percona Everest.

Have fun experimenting.

## How It Works Technically

1. **Control Panel**: This is a web service that can be opened in a browser. Through the interface, you can add connections to databases. You can load the dataset by clicking the button. Enable and manage the load. The service is developed in Go and stores settings in the [Valkey](https://valkey.io/) database. Other services read settings from Valkey.
2. **Dataset Loader**: The service developed in Go can load a dataset via GitHub API or from a CSV file. The service stores the dataset in memory, and any time you click the Import Dataset button for some database, it will load it into the database with Insert queries.
3. **Load Generator**: The service opens the number of concurrent connections to the database in separate go routines (threads) specified on the control panel. An infinite loop is started in each connection, and SQL and NoSQL queries are executed. The queries depend on the switches on the control panel. Every 2 seconds, it checks the load settings in Valkey and generates SQL and NoSQL queries accordingly. These queries are defined in `internal/load/load.go`. We also call the Sleep function in each iteration of the loop to simulate the delay for the business logic. Sleep in milliseconds is set in the control panel for each database.

## Development Environment

0. Run the environment:

   ```bash
   docker compose -p demo-app -f docker/dev.yaml up -d
   ```

   This will start the Valkey required for the application services and the three databases (MySQL 8.4, MongoDB 8, Postgres 17). Edit docker/dev.yaml if you need other databases or versions.

1. Run the Control Panel script:

   ```go
   go run cmd/web/main.go
   ```

   Launch the control panel at localhost:3000. Open the Settings tab and add connections. The control panel is a web application, the settings are saved in Valkey. 

2. Run the Dataset loader script

   ```go
   go run cmd/dataset/main.go
   ```

   This will start the load service. The service reads the configuration from Valkey according to the control panel and generates the load in separate Go routines.

3. Run the Dataset Loader script:

   ```go
   go run cmd/load/main.go
   ```

   Start PMM in your browser at `localhost:8080` (admin/admin).

## Release process of the new version

1. Test the application in a dev environment. Check the logs in the console.

2. Change the image versions for demo_app_dataset, demo_app_load, demo_app_web to the new version number in the files:

   *  `docker-compose.yaml`

   *  `docker/app.yaml`

   *  `docker/full.yaml`

   *  `k8s/helm/Chart.yaml`

   *  `k8s/helm/values.yaml` - images section

   *  `k8s/manual/*` - dataset-deployment.yaml, web-deployment.yaml, load-deployment.yaml files

3. Building and publishing to docker hub is done by GitHub Workflow by tag automatically. Set a new tag with the command:

   ```
   git tag -a 0.1.9 -m "Release 0.1.9"
   ``` 

   Publish a new tag

   ``` 
   git push origin 0.1.9
   ``` 

4. Check that the GitHub Action is successful and new versions are published on dockerhub. 

5. Test the application in docker and k8s

### Useful Commands

- Get Pods:

```bash
kubectl get pods -n demo
```

- View logs:

```bash
kubectl logs [pod_name] -n demo
```

- Describe Pods:

```bash
kubectl describe pod [pod_name] -n demo
```

## Contributing

1. Clone the repository and run locally using Docker Compose.

2. Make changes to the code and run scripts for tests.

3. The repository contains Workflow to build and publish to Docker Hub. You can publish your own versions of containers and run them in Kubernetes.

4. Send your changes to the project using Pull Request.

We welcome contributions:

1. Suggest improvements and create Issues
2. Improve code or do a review.

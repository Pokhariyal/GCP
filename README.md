<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgments">Acknowledgments</a></li>
  </ol>
</details>



<!-- ABOUT THE PROJECT -->
## Data Upstream<-CloudFunction->GCS->Bigquery->LookerDashboards

Repo that contains Visualization design, looker screens and code used to automate data ingestion(upstream gdrive,Website,SqlDB) to Downstream(Bigquery) for unlocking insight in Looker.

If you're working on cloud function, use requirements_cloud.txt. The code has a couple of changes similarly. Highly recommend working locally since it takes about 6 mins for every run of a cloud function.If you're working on your local machine, use requirements_local.txt. To install this file, use `pip install -r requirements_local.txt`.

##Figma Design of the Dashboard 
<img width="1440" alt="Dashboard" src="https://user-images.githubusercontent.com/101560010/207287068-9b30ec89-8ed3-4261-b182-cc830fe0f383.png">
<img width="1440" alt="DrillDown" src="https://user-images.githubusercontent.com/101560010/207287137-75a521d7-7376-4e8b-b6f0-9f9cec9faea6.png">



### Prerequisites

This is an example of how to list things you need to use the software and how to install them.
* npm
  ```sh
  pip install python
  ```

### Installation

1. Get a free API Key at [https://example.com](https://example.com)
2. Clone the repo
   ```sh
   git clone https://github.com/github_username/repo_name.git
   ```
3. Install  packages
   ```sh
   install
   ```
4. Enter your API in `config`
   ```js
   const API_KEY = 'ENTER YOUR API';
   ```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

# personality-box Overview

Personality Box pulls the .txt files from your [Box][box_url] acount and allows you to analyze the unique personality traits of each file's author using the Watson [Personality Insights API][personality_insights_url]. For sample files, feel free to use either [President Obama's 2015 State of the Union Address] [sotu_url] or [Moby Dick - Chapter 1] [moby_dick_url] hosted in our Box account.

[![Deploy to IBM Cloud](https://bluemix.net/deploy/button.png)](https://bluemix.net/deploy)

**Note**: If deploying by this method, the app will fail on first deploy. After this initial failure, you must complete steps 9-12 as described in the section 'Running the app on IBM Cloud' below for your app to start successfully.

## How it Works

1. Sign up for a [Box account] [box_signup_url] if you do not have one already.

2. Upload several txt files (we recommend each file contain a minimum of 3500 words) to the root folder of your account.

3. Navigate to the app home page and select 'Sign in with Box' to log in with your Box account.

4. Once your files load, select one to run its contents through the Personality Insights service and see the author's personality breakdown.

5. To view a visualization of the full result set, select the 'Full Personality Graph' button beneath the Big 5 results.

## Running the app on IBM Cloud

1. If you do not already have a Bluemix account, [sign up here][bluemix_signup_url]

2. Download and install the [Cloud Foundry CLI][cloud_foundry_url]

3. Clone the app to your local environment from your terminal using the following command

  ```
  git clone https://github.com/IBM-Cloud/box-watson.git
  ```

4. cd into this newly created directory

5. Edit the `manifest.yml` file and change the `<application-host>` parameter to something unique.

  ```
  applications:
  - name: personality-box
    host: personality-box
    framework: node
    runtime: node12
    memory: 128M
    instances: 1
  ```
  The host you use will determinate your application url (e.g. `<application-host>.mybluemix.net`)

6. Connect to IBM Cloud using the CF CLI and follow the prompts to log in.

  ```
  $ cf api https://api.ng.bluemix.net
  $ cf login
  ```

7. Create the Personality Insights service in IBM Cloud

  ```
  $ cf create-service personality_insights tiered personality-insights-box
  ```

8. Push your app to IBM Cloud. We need to perform additional steps once it is deployed, so we will add the option `--no-start` argument

  ```
  $ cf push --no-start
  ```

9. Next, you need to [sign up for a Box developer account][box_dev_signup_url] if you do not have one already

10. Once you have created an account, select 'Create a Box Application' from the side panel. Name your app, select the Box Content API, and click 'Create Application'. On the next page you will find your API key and your app's `client_id` and `client_secret`, which you will need for the following step.

11. Navigate to the [Box service][box_service_url] in the IBM Cloud Catalog. Select your recently created app to bind the service, name the service `box`, and fill out the `API Key`, `Client ID`, and `Client Secret` with the credentials you received in step 10.

12. Finally, we need to restage our app to ensure these env variable changes took effect

  ```
  $ cf restage APP_NAME
  ```

And voila! You now have your very own instance of Personality Box running on IBM Cloud.

## Running the app locally

1. If you do not already have a IBM Cloud account, [sign up here][bluemix_signup_url]

2. If you have not already, [download node.js][download_node_url] and install it on your local machine.

3. Clone the app to your local environment from your terminal using the following command

  ```
  git clone https://github.com/IBM-Cloud/box-watson.git
  ```

4. cd into this newly created directory

5. Install the required npm and bower packages using the following command

  ```
  npm install
  ```

6. Next, you need to sign up for a Box developer account if you do not have one already. You can do this [here][box_dev_signup_url].

7. Once you have created an account, select 'Create a Box Application' from the side panel. Name your app, select the Box Content API, and click 'Create Application'. On the next page you will find your API key and your app's `client_id` and `client_secret`, which you will need for the following step.

8. Using the credentials you received in step 7, replace the default Box configs in `vcap-local.json`.

9. Create a [Personality Insights service][pi_service_url] using your IBM Cloud account and replace the default credentials in `vcap-local.json`.

10. Start your app locally with the following command.

  ```
  npm start
  ```

Your app will be automatically assigned to a port which will be logged to your terminal. To access the app, go to localhost:PORT in your browser. Happy developing!

### Troubleshooting

To troubleshoot your IBM Cloud app the main useful source of information is the logs. To see them, run:

  ```
  $ cf logs personality-box --recent
  ```


[box_url]: https://www.box.com/
[personality_insights_url]: http://www.ibm.com/smarterplanet/us/en/ibmwatson/developercloud/personality-insights.html
[moby_dick_url]: https://app.box.com/s/xe4mv4tc7fi4mmuj6kgeurq0qvfv6ukd
[sotu_url]: https://app.box.com/s/bw5l1mtlodhib0yiu5rx4hyb9az7gt4m
[bluemix_signup_url]: http://ibm.biz/box-api-signup
[box_signup_url]: https://app.box.com/signup/personal
[box_dev_signup_url]: https://app.box.com/signup/o/default_developer_offer
[box_service_url]: https://console.ng.bluemix.net/catalog/services/box/
[pi_service_url]: https://console.ng.bluemix.net/catalog/services/personality-insights/
[cloud_foundry_url]: https://github.com/cloudfoundry/cli
[download_node_url]: https://nodejs.org/download/
[deploy_track_url]: https://github.com/cloudant-labs/deployment-tracker

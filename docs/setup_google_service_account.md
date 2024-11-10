# Setup: Google Drive Service Account

This guide explains how to set up a Google Drive service account to allow your application to access Google Drive files.

## Steps to Create a Google Drive Service Account

### 1. Create a Google Cloud Platform Project
1. Go to [Google Cloud Console](https://console.cloud.google.com/) and sign in.
2. Create a new project:
   - Click on "Select a Project" in the top left.
   - Click "New Project," name the project, and click "Create."

### 2. Enable the Google Drive API
1. Open your project in the Google Cloud Console.
2. Navigate to **APIs & Services > Library**.
3. Search for **Google Drive API** and click "Enable."

### 3. Create a Service Account
1. Go to **APIs & Services > Credentials**.
2. Click on **Create Credentials** and select **Service Account**.
3. Fill out the required information and assign the **Project > Owner** role.
4. Click **Done** to complete the setup.

### 4. Download the JSON Key
1. In **APIs & Services > Credentials**, locate your service account.
2. Click **Manage** to open the service account details.
3. Under the **Keys** tab, select **Add Key > Create New Key**.
4. Choose **JSON** as the key type, then download and save the file.

### 5. Configure Access with R

1. Place the JSON key file in a `.secrets` folder in your project directory.
2. In R, install and load the required libraries:
   ```r
   install.packages("googledrive")
   install.packages("gargle")

   library(googledrive)
   library(gargle)

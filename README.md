# 4Ever-Bock-Dashboard
The "4Ever-Bock-Dashboard" is an interactive R-Shiny-Dashboard that displays the current standings of the "4ever Bock" Doppelkopf community. Data is updated in real-time via a connected Google Sheet, allowing all members to stay up-to-date with the latest scores and statistics.

[Demo](https://faust-fx.shinyapps.io/4ever_bock_dashboard/)

# Instalation guide

To create and deploy the dashboard, the following accounts and resources are required:

    Google Drive: For accessing images and data sources.
    Shinyapps.io: For publishing the dashboard.
    
## Connecting R to Google Drive and Google Sheets

To connect R to Google Drive and Google Sheets, you need a Google Service Account. A detailed guide on creating a Service Account can be found [here](https://github.com/faust-x/4ever_bock_dashboard/blob/main/docs/setup_google_service_account.md).

Once the Service Account is set up, ensure it has access to the following data sources:

- [Google Sheet: Data](https://docs.google.com/spreadsheets/d/1rZDkXF7CPSkXcMSGHUp-KRwgnoBsgN-xqQqRO-GyGs8/edit?usp=sharing)
- [Google Drive: Images](https://drive.google.com/drive/folders/1a7Rn8z1eSw-xZPczU5vioYJh0eftK5dj?usp=sharing)

## Deployment on Shinyapps.io

The dashboard is deployed via RStudio.

- [4ever Bock Dashboard](https://faust-fx.shinyapps.io/4ever_bock_dashboard/)
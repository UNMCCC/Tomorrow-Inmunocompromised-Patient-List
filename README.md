Tomorrow Immunocompromised Patient List
=======================================

At the UNM Comprehensive Cancer Center, the providers, nurses and staff need to
pay special attention to those patients who are currently immunocompromised. To
that end, the first and foremost important thing is that the team understand
which patients maybe coming each day with a compromised immune system.

In the past, our Electronic Health System (Mosaiq) provided an indirect report
on Alerts created in the system. The nurses have to run said report manually to
gather this simple piece of information: who is coming, when where. This is too
time consuming.

We present here the main pieces that automated EHS data extraction regarding the
visiting next business day immunocompromised patients. The UNMCCC Tableau
delivers this list automatically to subscribers each business day evening, with
a link to the correponsing Tableau view.

To make this system work, a Mosaiq administrator would have to configure a type
of alert as immunocompromised. The nurse and staff teams will have to use the
alert system to annotate which patient has the condition, and make the alert
active. Using the SQL code provided here, we extract the list of
immunocompromised patients from the system for today.

We stage on MySQL the extracted immunocompromised patient data that Tableau
renders an easy to read list and distributes it to the subscribers, you will
find here a small load-data script for the staging table.

Requisites
==========

Our process and infrastructure is very specific, as we use Elekta’s Mosaiq
Health Information Systems as our Cancer Center system of record. Also, we use
an on-premise Tableau server to craft and distribute reports. Last, we have
custom staging environment powered by a simple MySQL database.

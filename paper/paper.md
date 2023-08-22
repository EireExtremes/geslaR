---
title: 'geslaR: An R package to deal with the GESLA dataset'
tags:
  - R
  - shiny
  - arrow
  - parquet
  - web interface
  - dataset
authors:
  - name: Fernando P. Mayer
    orcid: 0000-0001-5115-338X
    equal-contrib: true
    affiliation: 1 # (Multiple affiliations must be quoted)
    corresponding: true # (This is how to denote the corresponding author)
  - name: Niamh Cahill
    orcid: 0000-0003-3086-550X
    equal-contrib: true
    affiliation: 1
affiliations:
 - name: Department of Mathematics and Statistics, Maynooth University, Ireland
   index: 1
date: 11 August 2023
bibliography: ref.bib

# Optional fields if submitting to a AAS journal too, see this blog post:
# https://blog.joss.theoj.org/2018/12/a-new-collaboration-with-aas-publishing
# aas-doi: 10.3847/xxxxx <- update this with the DOI from AAS once you know it.
# aas-journal: Astrophysical Journal <- The name of the AAS journal.
---

# Summary

The GESLA (Global Extreme Sea Level Analysis) project aims to provide a
global database of higher-frequency sea-level records for researchers to
study tides, storm surges, extreme sea levels, and related processes.
Three versions of the GESLA dataset are available for download,
including a zip file containing the entire dataset, a CSV file
containing metadata, and a KML file for plotting the location of all
station records in Google Earth. The **geslaR** R package developed here
aims to facilitate the access to the GESLA dataset by providing
functions to download it entirely, or query subsets of it directly into
R, without the need of downloading the full dataset. Also, it provides a
built-in web-application, so that users can apply basic filters to
select the data of interest, generating informative plots, and showing
the selected sites all over the world. Users can download the selected
subset of data in CSV or Parquet file formats, with the latter being
recommended due to its smaller size and the ability to handle it in many
programming languages through the Apache Arrow language for in-memory
analytics. The web interface was developed using the Shiny R package,
with the CSV files from the GESLA dataset converted to the Parquet
format and stored in an Amazon AWS bucket.

# Statement of need

The first version of the GESLA dataset, denoted **GESLA-1** was made
available in 2009 [@Menendez2010]. An updated second
version, the **GESLA-2**, was assembled in 2015 and 2016, and released
in 2016 [@Woodworth2017]. The latest version, the
**GESLA-3**, was compiled in 2020 and 2021, and it is the one made
available at the official GESLA website for [download][], since November
2021 [@Haigh2021].

There are three files available for download, which, following the
website, are:

- A **zip** file containing the entire GESLA-3 dataset. The size of the
  zip file is 5.15 GB and when unzipped the data files are a total of
  38.72 GB
- A **csv** file containing the meta-data (e.g., station names, code,
  latitudes and longitudes, etc)
- A **KML** file for plotting the location of all the station records in
  google earth

Although the GESLA-3 dataset is freely available, the way it was
distributed could be a hurdle for many researchers. Anyone interested in
using the data for one (or more) specific locations, should have to
download all the CSV files, and then search for the desired data, and
possibly even merging several of them. The GESLA project also provides
two auxiliary scripts (in Python and Matlab), to help researchers to
handle and merge the desired subset of data. However, it is still
required that the entire dataset be downloaded. So far, no R scripts
were made available for R users.

The goal of this package is to facilitate access to the GESLA dataset,
without the need to download and handle all the files, which may be
computationally infeasible due to its large size.

There are three different ways the GESLA dataset can be fetched from
within R with the geslaR package:

- Downloading the full dataset with the `download_gesla()` function.
  This will download the full dataset locally, but in a set of Apache
  Parquet (`.parquet`) file formats, which are much smaller than the
  original CSV files (7GB compared to 38GB).
- Querying the full dataset directly from the host server with the
  `query_gesla()` function. This function allows the user to specify a
  particular set of countries, years and even site names. It will
  connect to an Amazon AWS bucket and filter the data direcly from
  there. The resulting object will be availabe in R, with only the
  particular required subset.
- Using the GESLA Shiny web application (geslaR-app) locally, via the
  `run_gesla_app()` function. When running this function for the first
  time, it will download the full dataset (in `.parquet` files), and
  open a Shiny application that allows the user to explore subsets of
  the full dataset, by applying filters for countries, years and sites.
  Once downloaded with the full dataset, this function can than be used
  to open the interface when desired. The user also has the option to
  export the selected subset in CSV or Parquet file formats.

Regardless of the way the GESLA dataset is loaded into R, the standard
way to deal with it is by using the Apache Arrow framework for in-memory
analytics. The Apache Arrow is a language-independent software to deal
with large datasets (larger-than-memory), in an effcient and fast way.
This framework can be used within R via the **arrow** R package, which
provides an interface between common **dplyr** verbs and the Arrow
language. By using the **arrow** package, datasets like GESLA which can
be larger-than-memory, can be handled within R, without the need to
actually load the data into memory, which is infeasible in most
practical situations.

The **geslaR** package also provides two more auxiliary functions:
`read_gesla()` and `write_gesla()`. In many situations, may be usefull
to save any subset of the dataset into a hard-drive file format, which
can then be read at any time. For example, when using the
`query_gesla()` function to fetch a specific subset, the user can save
the resulting R object to a file, so that they will not need to perform
the query again. The `write_gesla()` function will save an appropriate
file (CSV or Parquet), according to the class of the object. The
`read_gesla()` function can then be used to read that file again into R,
preserving the data correctly. This function can also be used to
read exported files from the geslaR-app.

It is worth mentioning that by accessing the geslaR-app interface, the
user has three basic filters available to select the data of interest:
country, year and site. The user can select one or more options in each
of these filters, and the resulting subset will be made available
through a sample of the subset (the "Data preview" tab)
(\autoref{fig:geslar}), some basic informative plots (the "Plots" tab),
and a map showing the selected sites all over the world (the "Map" tab).
Upon selection, the user can download only that subset of data. The
application is also available at this [link][]. However, frequent users
may benefit from having the local version provided by `run_gesla_app()`,
as it will be much faster than the hosted one.

<!-- The GESLA-3 dataset files were converted to the Parquet file format, for -->
<!-- easy of storage and manipulation, and is hosted in an Amazon AWS bucket. -->
<!-- However, the user can download any subset of data in CSV or Parquet. -->

![The fisrt page of the geslaR application, showing the "Data preview"
tab after basic filtering.\label{fig:geslar}](geslaR.png)

# Acknowledgements

This work has emanated from research conducted with the financial
support of Science Foundation Ireland and co-funded by GSI under Grant
number 20/FFP-P/8610. We also would like to thank the Hamilton Institute
at Maynooth University for hosting the application.

# References

[team of researchers]: https://gesla787883612.wordpress.com/team/
[download]: https://gesla787883612.wordpress.com/downloads/
[list of licenses]: https://gesla787883612.wordpress.com/license/
[official GESLA website]: https://gesla787883612.wordpress.com
[Apache Parquet]: https://parquet.apache.org
[Apache Arrow]: https://arrow.apache.org
[Shiny]: https://shiny.rstudio.com
[arrow]: https://arrow.apache.org/docs/r/
[link]: https://rstudioserver.hamilton.ie:3939/content/0c2283d9-a6cb-4887-9cb7-798ac1309858/

# Technical Debt Analysis in Open Source Startups

## Overview

This repository contains a collection of open source startups' repositories for analysis of technical debt and its impact on growth trajectories. The project is part of a research study titled "The Impact of Technical Debt on Startup Growth: A Longitudinal Analysis of Software Quality and Business Performance."

## Project Structure

- `open_source_startups/`: Parent directory containing all startup repositories
  - `[company_name]/`: Individual directories for each startup
    - `repo/`: The cloned repository of the startup's main open source product
    - `metadata.txt`: Information about founding year and funding

## Research Sample Selection

This project includes 100 open source startups selected based on the following criteria:
- Founded between 2010 and 2020 (to ensure a sufficient history for longitudinal analysis)
- Have received at least one round of venture funding
- Have a primary software product or platform with an open-source component
- Have a publicly accessible code repository

The selection focuses on startups rather than larger, established open source companies to better analyze the relationship between technical debt and growth in early-stage ventures.

## Usage

### Setup

1. Make the clone script executable:
   ```
   chmod +x clone_repos.sh
   ```

2. Run the script to clone all repositories:
   ```
   ./clone_repos.sh
   ```

3. The script will create a directory structure, clone each repository, and add metadata about founding year and funding.

### Analysis with SonarCloud

After cloning the repositories, you can analyze the technical debt metrics using SonarCloud:

1. Install SonarScanner and configure it for local analysis
2. For each repository, run the analysis to collect metrics such as:
   - Cognitive Complexity
   - Technical Debt Ratio
   - Code Duplication
   - Test Coverage

## Research Methodology

This project implements the methodology described in the research paper, focusing on:

1. Quantitative analysis of code quality metrics across startups founded between 2010-2020
2. Time series analysis of technical debt evolution over startup lifecycles
3. Correlation between technical debt and funding/growth indicators at different stages

The research aims to explore how different types of technical debt impact startup success across various funding stages and growth phases.

## Key Metrics

The analysis will focus on these key technical debt metrics:
- Technical Debt Ratio (remediation cost / development cost)
- Cognitive Complexity
- Code Duplication
- Test Coverage

These metrics will be analyzed in relation to growth indicators such as:
- Funding growth
- Valuation growth
- Deal frequency

## Data Sources

The project utilizes data from multiple sources:
- GitHub repositories for code analysis
- Funding and valuation data from the ROSS Index (Runa Capital), Crunchbase, and PitchBook
- Supplementary information from company websites and public announcements

## Contributing

This is a research project for academic purposes. If you'd like to contribute or have suggestions, please open an issue.

## License

This collection script is provided under the MIT license. Each repository has its own license which should be respected.

## Author

Max Heichling  
Technical University of Berlin  
Chair of Entrepreneurship and Innovation Management  
max@heichling.xyz
# 06 - Site Reliability Engineering (SRE)

Site Reliability Engineering (SRE) is what happens when you ask a software engineer to design an operations team. Pioneered by Google, it is a discipline that incorporates aspects of software engineering and applies them to infrastructure and operations problems.

## 1. SLIs, SLOs, and SLAs
You cannot manage what you do not measure. SRE relies on strict definitions of reliability.
- **SLI (Service Level Indicator):** A carefully defined quantitative measure of some aspect of the level of service that is provided. 
  - *Example:* The proportion of HTTP GET requests that respond successfully with a status code of 200 within 100ms.
- **SLO (Service Level Objective):** A target value or range of values for a service level that is measured by an SLI. This is your internal goal.
  - *Example:* 99.9% of requests in a month must succeed within 100ms.
- **SLA (Service Level Agreement):** A business contract with your users that dictates what happens (e.g., financial penalties or refunds) if the SLO is not met.

## 2. Error Budgets
100% reliability is the wrong target. It slows down feature delivery and is too expensive. If your SLO is 99.9%, you have a 0.1% **Error Budget** allowed for failures, downtime, or experiments.
- If you have plenty of error budget left, developers can deploy features rapidly.
- If the error budget is depleted for the month, feature deployments freeze, and the entire team shifts focus to stability, bug fixes, and paying down technical debt until the budget recovers. This aligns the incentives of Developers (who want to ship features) and Operations (who want stability).

## 3. Toil Reduction
"Toil" is the kind of work tied to running a production service that tends to be manual, repetitive, automatable, tactical, devoid of enduring value, and scales linearly as a service grows.
- SREs aim to cap toil at 50% of their time. The other 50% is spent writing software to automate that toil away permanently.

## 4. Incident Management and Blameless Postmortems
When things break (and they will):
- Establish clear roles: Incident Commander, Operations Lead, Communications Lead.
- **Blameless Postmortems:** After the incident is resolved, the team writes a document detailing what went wrong and how to fix it. *Crucially, you assume that everyone acted with the best intentions based on the information they had.* You investigate the systemic flaws that allowed the failure, not the human who made the error.

---
**Congratulations!** You now understand the tools and culture required to operate resilient software systems at scale. Head back to the [Main Syllabus](./README.md).

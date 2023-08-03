# FAQs for how to create drug codelists for recorded prescriptions

**Step 1 : Define purpose and value sets**   
[insert FAQs]
&nbsp;   
&nbsp;

**Step 2: Conducting search**  
<details><summary><i>Why are Steps 2a(ii) and 2b optional and database-dependent?</i> [Click to expand]</summary>Database might have missing data in search "attribute" variables. For example, in CPRD Aurum, the 2a(i) search attribute variables are <i>termfromemis</i> (i.e., term from EMIS software), <i>productname</i> (containing chemical and proprietary information), <i>drugsubstancename</i> (chemical information/recipe). Ideally if this database didn't have missing data, you would just search on *drugsubstancename* but there is so we search in 2a(i) using all these variables, and perform steps 2a(ii) and 2b.  
</details>
   
<details><summary><i>Why use slashes when searching on ontology in Step 2a(ii)?</i> [Click to expand]</summary>Medicines may be indicated for multiple conditions and hence recorded in multiple ontology sections (e.g., for *betamethasone* use slashes because may be recorded as both `“3020000”` and `“10010201/ 8020200/ 3020000”` within the ontology variable - corresponding to Ch. 10, Ch. 8, and Ch. 3 for neuromuscular, immunosuppression, and respiratory purposes) (in CPRD Aurum database the ontology variable is called *bnfchapter* ) </details>

<details><summary><i>How are outstanding codes identified in Step 2b?</i> [Click to expand]</summary>By comparing tags for columns corresponding to Step 2a(i) versus Step 2a(ii). Outstanding codes mean if there is an absence of a Step 2a(i) tag, but presence of a Step2a(ii) tag.
</details>

<details><summary><i>So what happens if I get outstanding codes in Step 2b?</i> [Click to expand]</summary>Add additional terms you get to value sets. Re-run steps 2a to 2b (ITERATIVELY - as necessary). Upon multiple iterations, there should be an absence of tags - indicating inclusion of all appropriate terms. (In rare cases in CPRD you'll have outstanding terms left that still show up, that neither fit your value sets nor the ontology, in which case these may be drugs that are miscoded or recently put on the market, perhaps).
</details>
&nbsp;     
&nbsp; 
&nbsp;  


**Step 3: Exclusions**
<details><summary><i>Why exclude?</i> [Click to expand]</summary>The broad search may pick up different medications with the same active chemical but of an inappropriate route, i.e., for a different medical indication corresponding to a different organ system (e.g., in a cardiovascular codelist, exclude "ocular" beta-blockers referring to medications given in the eye for glaucoma, instead of medications given by mouth to slow the heart) </details>
<details><summary><i>Why do we not recommend exclusions using product identifiers?</i> [Click to expand]</summary>Its a less transparent coding method. Product identifiers are numerical codes that don't contain qualitative information (name, route, formulation). To make the process more interpretable for others reading the script or for when the script is returned to in the future, we recommend avoiding eliminating codes based on their unique identifier alone. 
</details>  
&nbsp;          
&nbsp;
&nbsp;      

**Step 4: Cleaning**
<details><summary><i>In Step 4b, tell me more about what a code overlapping across ontological sections means?</i> [Click to expand]</summary>When a code for a fixed combination drug (consisting of multiple drug classes or mechanisms of action) it may be classified in various ontological sections (and therefore resides or could pertain to a different codelist) </details>
<details><summary><i>What is an example of a Step 4b tag?</i> [Click to expand]</summary>For example, <i>hydrochlorothiazide/captopril</i> is a single drug including both diuretic (BNF Ch. 2.2) and Renin-angiotensin-aldosterone system (RAAS) chemical components (BNF Ch. 2.5). So in a Ch. 2.5 hypertension/heart failure codelist for example, we would also tag it as BNF Ch. 2.2. </details> 
<details><summary><i>How does tagging overlapping codes across ontological sections help the codelist stay adaptable in analysis stage?</i> [Click to expand]</summary>If you have drug covariates, overlaps in class could present collinearity so you may choose to later exclude those tagged drug codes. (This depends on the size and nature of the codelist and cohort) </details>
<details><summary><i>How does tagging overlapping codes across ontological sections help the codelist stay adaptable in adaptaion stage?</i> [Click to expand]</summary>You might use these tags to adapt your codelist. Maybe you only care about single certain mechanism of action, and/or that drug doesn't make sense your study cohort. </details>    
&nbsp;  

**Step 5: Compare to previous codelists or mapping ontologies**    
<details><summary><i>Why do we care about previous versions?</i> [Click to expand]</summary>Comparison facilitates correct categorization and possible identification of outstanding codes from a previous codelist. </details>     
<details><summary><i>Where can I find a mapping resource for ATC-BNF?</i> [Click to expand]</summary>For CPRD Aurum, use [NHS Digital's TRUD site](https://isd.digital.nhs.uk/trud/users/guest/filters/0/categories/6/items/24/releases) </details>
<details><summary><i>Where can I find a mapping resource for ATC-BNF?</i> [Click to expand]</summary>For CPRD Aurum, use [NHS Digital's TRUD site](https://isd.digital.nhs.uk/trud/users/guest/filters/0/categories/6/items/24/releases) </details>
&nbsp;       
&nbsp;      
&nbsp;
&nbsp;  


**Step 6: Send "raw" codelist for clinician to review, to decide study-specific codelist**   
[insert FAQs]
&nbsp;          
&nbsp;  


**Step 7: Keep "master" codelist spreadsheet - with all versions and tags**   
<details><summary><i>Why keep a master codelist?</i> [Click to expand]</summary>For codelist adaptability and reproducibility (sensitivity analyses; generalization to future study contexts; harmonization between databases/contexts. </details>  





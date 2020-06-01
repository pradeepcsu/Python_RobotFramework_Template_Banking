*** Settings ***
Library           Selenium2Library
Library           Screenshot
Library           Host
Library           QuickApprove
Resource          ../../quickapprove_keywords.robot

*** Variables ***
${platinum ssn} =    452873412

*** Keywords ***
Classic
    [Documentation]    To create testing data for QA.
    Load Browser
    click on js    Main_StartNewApp
    click on    ChooseAppType_XpressApplication
    select list item js    Applicant_Branch_Dname    Bandera
    click on js    Applicant_Edit
    Register Window
    enter text    ApplicationReq_Edit_ZipCode    78249
    click on js    ApplicationReq_Edit_Continue
    click on js    AddAccount_Savings_Savings
    click on js    ProductsAndServices_Checking
    click on js    ProductsAndServices_Checking_ClassicChecking
    click on js    ProductsAndServices_AddATMDebitCard_2
    click on js    ApplicationReq_Edit_Save
    Unregister Window

    click on js    ApplicationReq_Next
    select list item js    Applicant_ElectStatements    NO
    click on js    CustomQuestions_Next

    Open TSSO
    ${ssn} =    Get New Member

    enter text js    Applicant_SSNvalue    ${ssn}
    pause testing    1
#    click on js    Applicant_QueryHost
    ${first name} =    Get Random String    4
    enter text js    Applicant_FirstName    ${first name}
    ${last name} =    Get Random String    4
    enter text js    Applicant_LastName    ${last name}
    enter text js    Applicant_HomePhoneNumber    2105555100
    enter text js    Applicant_DOB    7/20/1980
    select list item js    Applicant_EmploymentStatus    EMPLOYED
    enter text js    Applicant_EmploymentDuration_Year    2
    enter text js    Applicant_Employer    Test
    select list item js    Applicant_Occupation    CONSTRUCTION
    enter text js    Applicant_GrossIncome    5000
    ${id number} =    Get Random Alphanumeric String    8
    enter text js    Applicant_PrimaryID_Number    ${id number}
    select list item js    Applicant_PrimaryID_State    TX
    enter text js    Applicant_PrimaryID_Issued    8/4/2000
    enter text js    Applicant_PrimaryID_Expire    8/4/2017
    enter text js    Applicant_Address    123 Testing Street
    pause testing    duration=2
    enter text js    Applicant_Zip    78249
    select list item js    Applicant_OccupancyStatus    RENT
    enter text js    Applicant_OccupancyDuration_Years    2
    click on js    Applicant_QueryHost
    click on js    Applicant_QueryHost
    Register Window
    click on js    FieldOfMemebership_002
    click on js    FieldOfMemebership_SaveClose
    Unregister Window

#    click on js    AddNewApplicant    verify=Applicant_2
#
#    ${ssn} =    Get New Member
#    enter text js    Applicant_SSNvalue    ${ssn}
##    click on js    Applicant_QueryHost
#    ${first name} =    Get Random String    4
#    enter text js    Applicant_FirstName    ${first name}
#    ${last name} =    Get Random String    4
#    enter text js    Applicant_LastName    ${last name}
#    enter text js    Applicant_HomePhoneNumber    2105555100
#    enter text js    Applicant_DOB    7/20/1980
#    select list item js    Applicant_EmploymentStatus    EMPLOYED
#    enter text js    Applicant_EmploymentDuration_Year    2
#    enter text js    Applicant_Employer    Test
#    select list item js    Applicant_Occupation    CONSTRUCTION
#    enter text js    Applicant_GrossIncome    5000
#    ${id number} =    Get Random Alphanumeric String    8
#    enter text js    Applicant_PrimaryID_Number    ${id number}
#    select list item js    Applicant_PrimaryID_State    TX
#    enter text js    Applicant_PrimaryID_Issued    8/4/2000
#    enter text js    Applicant_PrimaryID_Expire    8/4/2017
#    enter text js    Applicant_Address    123 Testing Street
#    pause testing    duration=2
#    enter text js    Applicant_Zip    78249
#    select list item js    Applicant_OccupancyStatus    RENT
#    enter text js    Applicant_OccupancyDuration_Years    2
#    click on js    Applicant_QueryHost
#    click on js    Applicant_QueryHost
#    Register Window
#    click on js    FieldOfMemebership_002
#    click on js    FieldOfMemebership_SaveClose
#    Unregister Window

    click on js    CustomQuestions_Next
    Override Debit Bureau Results
    click on js    Underwriting_Next
    click on js    QualificationComments_ApprovedAccounts_Edit
    Register Window
    click on js    ProductsServices_CopyfromRequestAccounts
    click on js    ProductsServices_Save
    Unregister Window
    click on js    QualificationComments_Next

    ${current date} =    Get BCR Date
    #${current date} =    Get Current Date
#    enter text js    AccountInformation_IssueDate    ${current date}
#    click on js    AccountInformation_Next
    click on js    AccountInformation_Next

    # Pause Testing    5
#    enter text js    AccountInformation_IssueDate    ${current date}
    select list item js    AccountInformation_CombinedStatement_Dropdown    Savings
    click on js    AccountInformation_CombinedStatement_AddLink  js=yes
#    click on js    AccountInformation_CombinedStatement_AddLink
    pause testing  3
    click on js    AccountInformation_Next

    Pause Testing    10

    click on js    ATMInfo_AddCard_1
    Pause Testing    2
    Register Window
    select list item js    ATMInfo_AddCard_Type_1    DEBIT CARD
    select list item js    ATMInfo_AddCard_Rewards_1    NO
    Generate Card Number
    click on js    ATMInfo_AddCard_OrderPinYes
    click on js    ATMInfo_AddCard_OverdraftN
    click on js    ATMInfo_AddCard_OverdraftN
    select list item js    ATMInfo_AddCard_LinkToChecking    Classic Checking
    click on js    ATMInfo_AddCard_AddLinktoChecking
    click on js    ATMInfo_AddCard_SetPrimaryChecking
    select list item by index js    ATMInfo_AddCard_LinkToSaving    1
    click on js    ATMInfo_AddCard_AddLinktoSavings
    click on js    ATMInfo_AddCard_SetPrimarySavings
    click on js    ATMInfo_AddCard_Save
    Unregister Window

    click on js    ATMInfo_AddCard_1
    Pause Testing    2
    Register Window
    select list item js    ATMInfo_AddCard_Type_1    DEBIT CARD
    select list item js    ATMInfo_AddCard_Rewards_1    NO
    Generate Card Number
    click on js    ATMInfo_AddCard_OrderPinYes
    click on js    ATMInfo_AddCard_OverdraftN
    click on js    ATMInfo_AddCard_OverdraftN
    select list item js    ATMInfo_AddCard_LinkToChecking    Classic Checking
    click on js    ATMInfo_AddCard_AddLinktoChecking
    click on js    ATMInfo_AddCard_SetPrimaryChecking
    select list item by index js    ATMInfo_AddCard_LinkToSaving    1
    click on js    ATMInfo_AddCard_AddLinktoSavings
    click on js    ATMInfo_AddCard_SetPrimarySavings
    click on js    ATMInfo_AddCard_Save
    Unregister Window

    click on js    ATMInfo_AddCard_2
    Pause Testing    2
    Register Window
    select list item js    ATMInfo_AddCard_Type_1    DEBIT CARD
    select list item js    ATMInfo_AddCard_Rewards_1    NO
    Generate Card Number
    click on js    ATMInfo_AddCard_OrderPinYes
    click on js    ATMInfo_AddCard_OverdraftN
    click on js    ATMInfo_AddCard_OverdraftN
    select list item js    ATMInfo_AddCard_LinkToChecking    Classic Checking
    click on js    ATMInfo_AddCard_AddLinktoChecking
    click on js    ATMInfo_AddCard_SetPrimaryChecking
    select list item by index js    ATMInfo_AddCard_LinkToSaving    1
    click on js    ATMInfo_AddCard_AddLinktoSavings
    click on js    ATMInfo_AddCard_SetPrimarySavings
    click on js    ATMInfo_AddCard_Save
    Unregister Window

    click on js    ATMInfo_AddCard_2
    Pause Testing    2
    Register Window
    select list item js    ATMInfo_AddCard_Type_1    DEBIT CARD
    select list item js    ATMInfo_AddCard_Rewards_1    NO
    Generate Card Number
    click on js    ATMInfo_AddCard_OrderPinYes
    click on js    ATMInfo_AddCard_OverdraftN
    click on js    ATMInfo_AddCard_OverdraftN
    select list item js    ATMInfo_AddCard_LinkToChecking    Classic Checking
    click on js    ATMInfo_AddCard_AddLinktoChecking
    click on js    ATMInfo_AddCard_SetPrimaryChecking
    select list item by index js    ATMInfo_AddCard_LinkToSaving    1
    click on js    ATMInfo_AddCard_AddLinktoSavings
    click on js    ATMInfo_AddCard_SetPrimarySavings
    click on js    ATMInfo_AddCard_Save
    Unregister Window

    click on js    AccountFunding_Next
#   Account 1
    Click Type    AccountFunding_Amount1    5
    select list item js    AccountFunding_FundingSource1    CASH
    select list item js    AccountFunding_FundingStatus1    PROCESSING
    Pause Testing    duration=1
    Click Type    AccountFunding_Date1    ${current date}
#   Account 2
    Click Type    AccountFunding_Amount2    5
    select list item js    AccountFunding_FundingSource2    CASH
    select list item js    AccountFunding_FundingStatus2    PROCESSING
    Pause Testing    duration=1
    Click Type    AccountFunding_Date2    ${current date}
    click on js    AccountFunding_Next
    select list item js    AccountSummary_AccountRelationship    JOINT
    select list item js    AccountSummary_OwnerShiprights    OTHER
    click on js    AccountSummary_GetAccountNumbers
    Wait For Account Numbers
    click on js    AccountSummary_Next    verify=Letters/Docs_Next
    select list item js    Finalize_Status    APPROVED
    Accept Alert
    click on js    Letters/Docs_Next    verify=Finalize_CreateNewAccount
    click on js    Finalize_CreateNewAccount
    Register Window
    click on js    Finalize_Create
    Expect Text    CreateNewAccount_Confirmation    Your account has been successfully created.
    click on js    Finalize_Close
    Unregister Window
    click on js    Finalize_CreateNewAccount
    Register Window
    ${ssn} =    Get Element Text    Finalize_App_SSN
    ${cis} =    Get Element Text    Finalize_App_CIS
    @{debit card numbers} =    Get Debit Card Account Numbers
    Write To File    Classic    ${cis}    ${ssn}    @{debit card numbers}
    Close Window
    Unregister Window
    click on js    Exit_Application

Gold
    [Documentation]    To create testing data for QA.
    Load Browser
    click on js    Main_StartNewApp
    click on js    ChooseAppType_XpressApplication
    select list item js    Applicant_Branch_Dname    Bandera
    click on js    Applicant_Edit
    Register Window
    enter text js    ApplicationReq_Edit_ZipCode    78249
    click on js    ApplicationReq_Edit_Continue
    click on js    AddAccount_Savings_Savings
    click on js    ProductsAndServices_Checking
    click on js    ProductsAndServices_Checking_ClassicChecking
    click on js    ProductsAndServices_AddATMDebitCard_2
    click on js    ApplicationReq_Edit_Save
    Unregister Window
    click on js    ApplicationReq_Next
    select list item js    Applicant_ElectStatements    NO
    click on js    CustomQuestions_Next
    Open TSSO

    ${ssn} =    Get New Member
    Click Type    Applicant_SSNvalue    ${ssn}
    click on js    Applicant_QueryHost
    ${first name} =    Get Random String    4
    Click Type    Applicant_FirstName    ${first name}
    ${last name} =    Get Random String    4
    Click Type    Applicant_LastName    ${last name}
    Click Type    Applicant_HomePhoneNumber    2105555100
    Click Type    Applicant_DOB    7/20/1980
    select list item js    Applicant_EmploymentStatus    EMPLOYED
    Click Type    Applicant_EmploymentDuration_Year    2
    Click Type    Applicant_Employer    Test
    select list item js    Applicant_Occupation    CONSTRUCTION
    Click Type    Applicant_GrossIncome    5000
    ${id number} =    Get Random Alphanumeric String    8
    Click Type    Applicant_PrimaryID_Number    ${id number}
    select list item js    Applicant_PrimaryID_State    TX
    Click Type    Applicant_PrimaryID_Issued    8/4/2000
    Click Type    Applicant_PrimaryID_Expire    8/4/2017
    Click Type    Applicant_Address    123 Testing Street
    Click Type    Applicant_Zip    78249
    select list item js    Applicant_OccupancyStatus    RENT
    Click Type    Applicant_OccupancyDuration_Years    2
    click on js    Applicant_QueryHost
    click on js    Applicant_QueryHost
    Register Window
    click on js    FieldOfMemebership_002
    click on js    FieldOfMemebership_SaveClose
    Unregister Window

    click on js    AddNewApplicant    verify=Applicant_2

    ${ssn} =    Get New Member
    Click Type    Applicant_SSNvalue    ${ssn}
    click on js    Applicant_QueryHost
    ${first name} =    Get Random String    4
    Click Type    Applicant_FirstName    ${first name}
    ${last name} =    Get Random String    4
    Click Type    Applicant_LastName    ${last name}
    Click Type    Applicant_HomePhoneNumber    2105555100
    Click Type    Applicant_DOB    7/20/1980
    select list item js    Applicant_EmploymentStatus    EMPLOYED
    Click Type    Applicant_EmploymentDuration_Year    2
    Click Type    Applicant_Employer    Test
    select list item js    Applicant_Occupation    CONSTRUCTION
    Click Type    Applicant_GrossIncome    5000
    ${id number} =    Get Random Alphanumeric String    8
    Click Type    Applicant_PrimaryID_Number    ${id number}
    select list item js    Applicant_PrimaryID_State    TX
    Click Type    Applicant_PrimaryID_Issued    8/4/2000
    Click Type    Applicant_PrimaryID_Expire    8/4/2017
    Click Type    Applicant_Address    123 Testing Street
    Click Type    Applicant_Zip    78249
    select list item js    Applicant_OccupancyStatus    RENT
    Click Type    Applicant_OccupancyDuration_Years    2
    click on js    Applicant_QueryHost
    click on js    Applicant_QueryHost
    Register Window
    click on js    FieldOfMemebership_002
    click on js    FieldOfMemebership_SaveClose
    Unregister Window

    click on js    CustomQuestions_Next
    Override Debit Bureau Results
    click on js    Underwriting_Next
    click on js    QualificationComments_ApprovedAccounts_Edit
    Register Window
    click on js    ProductsServices_CopyfromRequestAccounts
    click on js    ProductsServices_Save
    Unregister Window
    click on js    QualificationComments_Next

    ${current date} =    Get BCR Date
    #${current date} =    Get Current Date
    enter text js    AccountInformation_IssueDate    ${current date}
    click on js    AccountInformation_Next

    enter text js    AccountInformation_IssueDate    ${current date}
    select list item js    AccountInformation_CombinedStatement_Dropdown    Savings
    click on js    AccountInformation_CombinedStatement_AddLink
#    click on js    AccountInformation_CombinedStatement_AddLink
    click on js    AccountInformation_Next    verify=ATMInfo_AddCard_1

    click on js    ATMInfo_AddCard_1
    Register Window
    select list item js    ATMInfo_AddCard_Type_1    DEBIT CARD
    select list item js    ATMInfo_AddCard_Rewards_1    CLASSIC POINTS
    Generate Card Number
    click on js    ATMInfo_AddCard_OrderPinYes
    click on js    ATMInfo_AddCard_OverdraftN
    click on js    ATMInfo_AddCard_OverdraftN
    select list item js    ATMInfo_AddCard_LinkToChecking    Classic Checking
    click on js    ATMInfo_AddCard_AddLinktoChecking
    click on js    ATMInfo_AddCard_SetPrimaryChecking
    select list item js By Index    ATMInfo_AddCard_LinkToSaving    1
    click on js    ATMInfo_AddCard_AddLinktoSavings
    click on js    ATMInfo_AddCard_SetPrimarySavings
    click on js    ATMInfo_AddCard_Save
    Unregister Window

    click on js    ATMInfo_AddCard_1
    Register Window
    select list item js    ATMInfo_AddCard_Type_1    DEBIT CARD
    select list item js    ATMInfo_AddCard_Rewards_1    CLASSIC POINTS
    Generate Card Number
    click on js    ATMInfo_AddCard_OrderPinYes
    click on js    ATMInfo_AddCard_OverdraftN
    click on js    ATMInfo_AddCard_OverdraftN
    select list item js    ATMInfo_AddCard_LinkToChecking    Classic Checking
    click on js    ATMInfo_AddCard_AddLinktoChecking
    click on js    ATMInfo_AddCard_SetPrimaryChecking
    select list item js By Index    ATMInfo_AddCard_LinkToSaving    1
    click on js    ATMInfo_AddCard_AddLinktoSavings
    click on js    ATMInfo_AddCard_SetPrimarySavings
    click on js    ATMInfo_AddCard_Save
    Unregister Window

    click on js    ATMInfo_AddCard_2
    Register Window
    select list item js    ATMInfo_AddCard_Type_1    DEBIT CARD
    select list item js    ATMInfo_AddCard_Rewards_1    CLASSIC POINTS
    Generate Card Number
    click on js    ATMInfo_AddCard_OrderPinYes
    click on js    ATMInfo_AddCard_OverdraftN
    click on js    ATMInfo_AddCard_OverdraftN
    select list item js    ATMInfo_AddCard_LinkToChecking    Classic Checking
    click on js    ATMInfo_AddCard_AddLinktoChecking
    click on js    ATMInfo_AddCard_SetPrimaryChecking
    select list item js By Index    ATMInfo_AddCard_LinkToSaving    1
    click on js    ATMInfo_AddCard_AddLinktoSavings
    click on js    ATMInfo_AddCard_SetPrimarySavings
    click on js    ATMInfo_AddCard_Save
    Unregister Window

    click on js    ATMInfo_AddCard_2
    Register Window
    select list item js    ATMInfo_AddCard_Type_1    DEBIT CARD
    select list item js    ATMInfo_AddCard_Rewards_1    CLASSIC POINTS
    Generate Card Number
    click on js    ATMInfo_AddCard_OrderPinYes
    click on js    ATMInfo_AddCard_OverdraftN
    click on js    ATMInfo_AddCard_OverdraftN
    select list item js    ATMInfo_AddCard_LinkToChecking    Classic Checking
    click on js    ATMInfo_AddCard_AddLinktoChecking
    click on js    ATMInfo_AddCard_SetPrimaryChecking
    select list item js By Index    ATMInfo_AddCard_LinkToSaving    1
    click on js    ATMInfo_AddCard_AddLinktoSavings
    click on js    ATMInfo_AddCard_SetPrimarySavings
    click on js    ATMInfo_AddCard_Save
    Unregister Window

    click on js    AccountFunding_Next
    Click Type    AccountFunding_Amount1    5
    select list item js    AccountFunding_FundingSource1    CASH
    select list item js    AccountFunding_FundingStatus1    PROCESSING
    Pause Testing    duration=1
    Click Type    AccountFunding_Date1    ${current date}
    Click Type    AccountFunding_Amount2    5
    select list item js    AccountFunding_FundingSource2    CASH
    select list item js    AccountFunding_FundingStatus2    PROCESSING
    Pause Testing    duration=1
    Click Type    AccountFunding_Date2    ${current date}
    click on js    AccountFunding_Next
    select list item js    AccountSummary_AccountRelationship    JOINT
    select list item js    AccountSummary_OwnerShiprights    OTHER
    click on js    AccountSummary_GetAccountNumbers
    Wait For Account Numbers
    click on js    AccountSummary_Next    verify=Letters/Docs_Next
    select list item js    Finalize_Status    APPROVED
    Accept Alert
    click on js    Letters/Docs_Next    verify=Finalize_CreateNewAccount
    click on js    Finalize_CreateNewAccount
    Register Window
    click on js    Finalize_Create
    Expect Text    CreateNewAccount_Confirmation    Your account has been successfully created.
    click on js    Finalize_Close
    Unregister Window
    click on js    Finalize_CreateNewAccount
    Register Window
    ${ssn} =    Get Element Text    Finalize_App_SSN
    ${cis} =    Get Element Text    Finalize_App_CIS
    @{debit card numbers} =    Get Debit Card Account Numbers
    Write To File    Gold    ${cis}    ${ssn}    @{debit card numbers}
    Close Window
    Unregister Window
    click on js    Exit_Application

Platinum
    [Documentation]    To create testing data for QA.
#    Set Selenium Speed    .05
    Load Browser
    click on js    Main_StartNewApp
    click on js    ChooseAppType_XpressApplication
    select list item js    Applicant_Branch_Dname    Bandera
    click on js    Applicant_Edit
    Register Window
    enter text js    ApplicationReq_Edit_ZipCode    78249
    click on js    ApplicationReq_Edit_Continue
    click on js    AddAccount_Savings_Savings
    click on js    ProductsAndServices_Checking
    click on js    ProductsAndServices_Checking_ClassicChecking
    click on js    ProductsAndServices_AddATMDebitCard_2
    click on js    ApplicationReq_Edit_Save
    Unregister Window
    click on js    ApplicationReq_Next
    select list item js    Applicant_ElectStatements    NO
    click on js    CustomQuestions_Next

    Click Type    Applicant_SSNvalue    ${platinum ssn}
    Update Application    expect_popup=True
    Click Type    Applicant_HomePhoneNumber    2105555100    if_not=
    Click Type    Applicant_WorkPhoneNumber    2105555101
    Click Type    Applicant_DOB    7/20/1980    if_not=
    select list item js    Applicant_EmploymentStatus    EMPLOYED
    Click Type    Applicant_EmploymentDuration_Year    2
    Click Type    Applicant_Employer    Test
    select list item js    Applicant_Occupation    CONSTRUCTION
    Click Type    Applicant_GrossIncome    5000
    ${id number} =    Get Random Alphanumeric String    8
    Click Type    Applicant_PrimaryID_Number    ${id number}    if_not=
    select list item js    Applicant_PrimaryID_State    TX    if_not=
    Click Type    Applicant_PrimaryID_Issued    8/4/2000    if_not=
    Click Type    Applicant_PrimaryID_Expire    8/4/2017    if_not=
    Click Type    Applicant_Address    123 Testing Street    if_not=
    Click Type    Applicant_Zip    78249    if_not=
    select list item js    Applicant_OccupancyStatus    RENT    if_not=
    Click Type    Applicant_OccupancyDuration_Years    2    if_not=0

    click on js    AddNewApplicant    verify=Applicant_2

    Open TSSO
    ${ssn} =    Get New Member
    Click Type    Applicant_SSNvalue    ${ssn}
    click on js    Applicant_QueryHost
    ${first name} =    Get Random String    4
    Click Type    Applicant_FirstName    ${first name}
    ${last name} =    Get Random String    4
    Click Type    Applicant_LastName    ${last name}
    Click Type    Applicant_HomePhoneNumber    2105555100
    Click Type    Applicant_DOB    7/20/1980
    select list item js    Applicant_EmploymentStatus    EMPLOYED
    Click Type    Applicant_EmploymentDuration_Year    2
    Click Type    Applicant_Employer    Test
    select list item js    Applicant_Occupation    CONSTRUCTION
    Click Type    Applicant_GrossIncome    5000
    ${id number} =    Get Random Alphanumeric String    8
    Click Type    Applicant_PrimaryID_Number    ${id number}
    select list item js    Applicant_PrimaryID_State    TX
    Click Type    Applicant_PrimaryID_Issued    8/4/2000
    Click Type    Applicant_PrimaryID_Expire    8/4/2017
    Click Type    Applicant_Address    123 Testing Street
    Click Type    Applicant_Zip    78249
    select list item js    Applicant_OccupancyStatus    RENT
    Click Type    Applicant_OccupancyDuration_Years    2
    click on js    Applicant_QueryHost
    click on js    Applicant_QueryHost
    Register Window
    click on js    FieldOfMemebership_002
    click on js    FieldOfMemebership_SaveClose
    Unregister Window

    click on js    CustomQuestions_Next
    Override Debit Bureau Results    ssn=${platinum ssn}
    click on js    Underwriting_Next
    click on js    QualificationComments_ApprovedAccounts_Edit
    Register Window
    click on js    ProductsServices_CopyfromRequestAccounts
    click on js    ProductsServices_Save
    Unregister Window
    click on js    QualificationComments_Next

    ${current date} =    Get BCR Date
    #${current date} =    Get Current Date
    enter text js    AccountInformation_IssueDate    ${current date}
    click on js    AccountInformation_Next
    enter text js    AccountInformation_IssueDate    ${current date}
    select list item js    AccountInformation_CombinedStatement_Dropdown    Savings
    click on js    AccountInformation_CombinedStatement_AddLink
#    click on js    AccountInformation_CombinedStatement_AddLink
    click on js    AccountInformation_Next    verify=ATMInfo_AddCard_1

    click on js    ATMInfo_AddCard_1
    Register Window
    select list item js    ATMInfo_AddCard_Type_1    DEBIT CARD
    select list item js    ATMInfo_AddCard_Rewards_1    CLASSIC POINTS
    Generate Card Number
    click on js    ATMInfo_AddCard_OrderPinYes
    click on js    ATMInfo_AddCard_OverdraftN
    click on js    ATMInfo_AddCard_OverdraftN
    select list item js    ATMInfo_AddCard_LinkToChecking    Classic Checking
    click on js    ATMInfo_AddCard_AddLinktoChecking
    click on js    ATMInfo_AddCard_SetPrimaryChecking
    select list item js    ATMInfo_AddCard_LinkToSaving    Savings
    click on js    ATMInfo_AddCard_AddLinktoSavings    verify=ATMInfo_AddCard_SetPrimarySavings
    click on js    ATMInfo_AddCard_SetPrimarySavings
    click on js    ATMInfo_AddCard_Save
    Unregister Window

    click on js    ATMInfo_AddCard_1
    Register Window
    select list item js    ATMInfo_AddCard_Type_1    DEBIT CARD
    select list item js    ATMInfo_AddCard_Rewards_1    CLASSIC POINTS
    Generate Card Number
    click on js    ATMInfo_AddCard_OrderPinYes
    click on js    ATMInfo_AddCard_OverdraftN
    click on js    ATMInfo_AddCard_OverdraftN
    select list item js    ATMInfo_AddCard_LinkToChecking    Classic Checking
    click on js    ATMInfo_AddCard_AddLinktoChecking
    click on js    ATMInfo_AddCard_SetPrimaryChecking
    select list item js    ATMInfo_AddCard_LinkToSaving    Savings
    click on js    ATMInfo_AddCard_AddLinktoSavings    verify=ATMInfo_AddCard_SetPrimarySavings
    click on js    ATMInfo_AddCard_SetPrimarySavings
    click on js    ATMInfo_AddCard_Save
    Unregister Window

    click on js    ATMInfo_AddCard_2
    Register Window
    select list item js    ATMInfo_AddCard_Type_1    DEBIT CARD
    select list item js    ATMInfo_AddCard_Rewards_1    CLASSIC POINTS
    Generate Card Number
    click on js    ATMInfo_AddCard_OrderPinYes
    click on js    ATMInfo_AddCard_OverdraftN
    click on js    ATMInfo_AddCard_OverdraftN
    select list item js    ATMInfo_AddCard_LinkToChecking    Classic Checking
    click on js    ATMInfo_AddCard_AddLinktoChecking
    click on js    ATMInfo_AddCard_SetPrimaryChecking
    select list item js    ATMInfo_AddCard_LinkToSaving    Savings
    click on js    ATMInfo_AddCard_AddLinktoSavings    verify=ATMInfo_AddCard_SetPrimarySavings
    click on js    ATMInfo_AddCard_SetPrimarySavings
    click on js    ATMInfo_AddCard_Save
    Unregister Window

    click on js    ATMInfo_AddCard_2
    Register Window
    select list item js    ATMInfo_AddCard_Type_1    DEBIT CARD
    select list item js    ATMInfo_AddCard_Rewards_1    CLASSIC POINTS
    Generate Card Number
    click on js    ATMInfo_AddCard_OrderPinYes
    click on js    ATMInfo_AddCard_OverdraftN
    click on js    ATMInfo_AddCard_OverdraftN
    select list item js    ATMInfo_AddCard_LinkToChecking    Classic Checking
    click on js    ATMInfo_AddCard_AddLinktoChecking
    click on js    ATMInfo_AddCard_SetPrimaryChecking
    select list item js    ATMInfo_AddCard_LinkToSaving    Savings
    click on js    ATMInfo_AddCard_AddLinktoSavings    verify=ATMInfo_AddCard_SetPrimarySavings
    click on js    ATMInfo_AddCard_SetPrimarySavings
    click on js    ATMInfo_AddCard_Save
    Unregister Window

    click on js    AccountFunding_Next

    Click Type    AccountFunding_Amount1    5
    select list item js    AccountFunding_FundingSource1    CASH
    select list item js    AccountFunding_FundingStatus1    PROCESSING
    Pause Testing    duration=1
    Click Type    AccountFunding_Date1    ${current date}

    Click Type    AccountFunding_Amount2    5
    select list item js    AccountFunding_FundingSource2    CASH
    select list item js    AccountFunding_FundingStatus2    PROCESSING
    Pause Testing    duration=1
    Click Type    AccountFunding_Date2    ${current date}

    click on js    AccountFunding_Next

    select list item js    AccountSummary_AccountRelationship    JOINT
    select list item js    AccountSummary_OwnerShiprights    OTHER
    click on js    AccountSummary_GetAccountNumbers
    Wait For Account Numbers
    click on js    AccountSummary_Next    verify=Letters/Docs_Next
    select list item js    Finalize_Status    APPROVED
    Accept Alert
    click on js    Letters/Docs_Next    verify=Finalize_CreateNewAccount
    click on js    Finalize_CreateNewAccount
    Register Window
    click on js    Finalize_Create
    Expect Text    CreateNewAccount_Confirmation    Your account has been successfully created.
    click on js    Finalize_Close
    Unregister Window
    click on js    Finalize_CreateNewAccount
    Register Window
    ${ssn} =    Get Element Text    Finalize_App_SSN
    ${cis} =    Get Element Text    Finalize_App_CIS
    @{debit card numbers} =    Get Debit Card Account Numbers
    Write To File    Platinum    ${cis}    ${ssn}    @{debit card numbers}
    Close Window
    Unregister Window
    click on js    Exit_Application

*** Test Cases ***
Create Classic
    Classic

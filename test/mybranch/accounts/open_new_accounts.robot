*** Settings ***
Library           Selenium2Library
Library           Screenshot
Library           MyBranch
Resource          ../mybranch_keywords.robot

*** Test Cases ***
Open New Accounts - Certificate Account
    [Documentation]    Account Origination - Open a new CD account.
    [Tags]    qa_suite    new_test
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}
    Click On    Ribbon_Accounts
    Click On    LeftNav_OpenNewAccounts
    Click On    LeftNav_OpenNewAccounts_DepositAccounts
    # Select Aria List Item    OpenNewAccounts_ProductTypeList    Certificate Account
    select kendo dropdown    OpenNewAccounts_ProductTypeList    Certificate Account
    Sleep    60
    Open New Certificate Account    $250.00    1 Year Future Builder Certificate
    Select Aria List Item    OpenNewAccounts_FundingDetails_TransferFundsFrom    Other Financial Institution
    Enter Aria Text    OpenNewAccounts_FundingDetails_OpeningDeposit    250.00
    Select Aria List Item    OpenNewAccounts_FundingDetails_AccountType    Checking
    Enter Text    OpenNewAccounts_FundingDetails_NameOnAccount    Test Member
    Enter Text    OpenNewAccounts_FundingDetails_AccountNo    101010101
    Enter Text    OpenNewAccounts_FundingDetails_RoutingNo    314074269
    Capture Page Screenshot
    Click On    OpenNewAccounts_FundingDetails_Next
    Expect Text    OpenNewAccounts_VerifyFundingDetails_TransferFundsFrom    Other Financial Institution
    Expect Text    OpenNewAccounts_VerifyFundingDetails_OpeningDeposit    $250.00
    Expect Text    OpenNewAccounts_VerifyFundingDetails_AccountType    CHECKING
    Expect Text    OpenNewAccounts_VerifyFundingDetails_NameOnAccount    Test Member
    Expect Text    OpenNewAccounts_VerifyFundingDetails_AccountNo    101010101
    Expect Text    OpenNewAccounts_VerifyFundingDetails_RoutingNo    314074269
    Expect Text    OpenNewAccounts_VerifyFundingDetails_FinancialInstitution    USAA FEDERAL SAVINGS BANK
    Expect Text    OpenNewAccounts_VerifyFundingDetails_State    TX
    Enter Text    OpenNewAccounts_VerifyFundingDetails_Comments    Test comments.
    Capture Page Screenshot
    Click On    OpenNewAccounts_VerifyFundingDetails_Submit
    Exists    OpenNewAccounts_Confirmation
    Capture Page Screenshot
    [Teardown]    Log Out myBranch

Open New Accounts - Money Market
    [Documentation]    Account Origination - Open a new Monkey Market account.
    [Tags]    qa_suite    new_test
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}
    Click On    Ribbon_Accounts
    Click On    LeftNav_OpenNewAccounts
    Click On    LeftNav_OpenNewAccounts_DepositAccounts
    select kendo dropdown    OpenNewAccounts_ProductTypeList    Money Market
    Open New Money Market    $0.00
    Select Aria List Item    OpenNewAccounts_FundingDetails_TransferFundsFrom    Security Service Account
    Enter Aria Text    OpenNewAccounts_FundingDetails_OpeningDeposit    5.00
    Select Aria List Item    OpenNewAccounts_FundingDetails_FundingAccount    ${funding_account}
    Capture Page Screenshot
    Click On    OpenNewAccounts_FundingDetails_Next
    Expect Text    OpenNewAccounts_VerifyFundingDetails_TransferFundsFrom    Security Service Account
    Expect Text    OpenNewAccounts_VerifyFundingDetails_OpeningDeposit    $5.00
    Expect Text    OpenNewAccounts_VerifyFundingDetails_FundingAccount    ${funding_account}
    Enter Text    OpenNewAccounts_VerifyFundingDetails_Comments    Test comments.
    Capture Page Screenshot
    Click On    OpenNewAccounts_VerifyFundingDetails_Submit
    Exists    OpenNewAccounts_Confirmation
    Capture Page Screenshot
    [Teardown]    Log Out myBranch

Open New Deposit Accounts - Verify Disclosures
    [Documentation]    Open New Deposit Accounts - Apply for Power Protected Checking Account(Product Code 690)
    [Tags]    new_test
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}
    Click On    Ribbon_Accounts
    Click On    LeftNav_OpenNewAccounts
    Click On    LeftNav_OpenNewAccounts_DepositAccounts
    Exists    OpenNewAccount_DepositAccount_Disclosure1
    Exists    OpenNewAccount_DepositAccount_Disclosure2
    Exists    OpenNewAccount_DepositAccount_Disclosure3
    Exists    OpenNewAccount_Disclosure_AllabtAccountLink
    Exists    OpenNewAccount_Disclosure_TruthSavingsLink
    Exists    OpenNewAccount_Disclosure_DepositAccountLink
    ${disclosure1}=  get element attribute    xpath=(/html/body/div[1]/div[2]/div[3]/div[2]/div/div[3]/div/div[1]/a[1])@href
    Should Contain      ${disclosure1}    https://www.ssfcu.org/SiteCollectionDocuments/application-disclosures/deposittc
    ${disclosure2}=  get element attribute    xpath=(/html/body/div[1]/div[2]/div[3]/div[2]/div/div[3]/div/div[1]/a[2])@href
    Should Contain      ${disclosure2}    https://www.ssfcu.org/SiteCollectionDocuments/application-disclosures/truthinsavings
    ${disclosure3}=  get element attribute    xpath=(/html/body/div[1]/div[2]/div[3]/div[2]/div/div[3]/div/div[1]/a[3])@href
    Should Contain      ${disclosure3}    https://www.ssfcu.org/SiteCollectionDocuments/application-disclosures/consumer-fee-schedule

    [Teardown]    Log Out myBranch

Open New Deposit Accounts - Apply for Power Protected Checking Account
    [Documentation]    Open New Deposit Accounts - Apply for Power Protected Checking Account(Product Code 690)
    ...    Minimum opening deposit: $25.00 Monthly account service charge: $6.00
    [Tags]    new_test
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}

    Click On    Ribbon_Accounts
    Click On    LeftNav_OpenNewAccounts
    Click On    LeftNav_OpenNewAccounts_DepositAccounts
    select kendo dropdown    OpenNewAccounts_ProductTypeList    Checking
    click on    OpenNewAccounts_PPC
    assert page contains    Fund Your New Deposit Account
    assert page contains    Power Protected Checking

    Select Aria List Item    OpenNewAccounts_FundingDetails_TransferFundsFrom    Security Service Account
    Enter Aria Text    OpenNewAccounts_FundingDetails_OpeningDeposit    25.00
    Select Aria List Item    OpenNewAccounts_FundingDetails_FundingAccount    ${funding_account}
    Capture Page Screenshot
    Click On    OpenNewAccounts_FundingDetails_Next
    Expect Text    OpenNewAccounts_VerifyFundingDetails_TransferFundsFrom    Security Service Account
    Expect Text    OpenNewAccounts_VerifyFundingDetails_OpeningDeposit    $25.00
    Expect Text    OpenNewAccounts_VerifyFundingDetails_FundingAccount    ${funding_account}
    Enter Text    OpenNewAccounts_VerifyFundingDetails_Comments    Test comments.
    Capture Page Screenshot
    Click On    OpenNewAccounts_VerifyFundingDetails_Submit
    sleep    2
    Exists    OpenNewAccounts_Confirmation
    Capture Page Screenshot

    [Teardown]    Log Out myBranch

Open New Deposit Accounts - Apply for Power Checking Account
    [Documentation]    Test to verify the members can apply for Power Checking(700)
    ...    Minimum opening deposit: $25.00 Monthly account service charge: $6.00
    [Tags]    new_test
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}

    Click On    Ribbon_Accounts
    Click On    LeftNav_OpenNewAccounts
    Click On    LeftNav_OpenNewAccounts_DepositAccounts
    select kendo dropdown    OpenNewAccounts_ProductTypeList    Checking
    click on    OpenNewAccounts_PC
    assert page contains    Fund Your New Deposit Account
    assert page contains    Power Checking

    Select Aria List Item    OpenNewAccounts_FundingDetails_TransferFundsFrom    Security Service Account
    Enter Aria Text    OpenNewAccounts_FundingDetails_OpeningDeposit    25.00
    Select Aria List Item    OpenNewAccounts_FundingDetails_FundingAccount    ${funding_account}
    Capture Page Screenshot
    Click On    OpenNewAccounts_FundingDetails_Next
    Expect Text    OpenNewAccounts_VerifyFundingDetails_TransferFundsFrom    Security Service Account
    Expect Text    OpenNewAccounts_VerifyFundingDetails_OpeningDeposit    $25.00
    Expect Text    OpenNewAccounts_VerifyFundingDetails_FundingAccount    ${funding_account}
    Enter Text    OpenNewAccounts_VerifyFundingDetails_Comments    Test comments.
    Capture Page Screenshot
    Click On    OpenNewAccounts_VerifyFundingDetails_Submit
    sleep    2
    Exists    OpenNewAccounts_Confirmation
    Capture Page Screenshot

    [Teardown]    Log Out myBranch

Open New Deposit Accounts - Verify Product Rates for Power Checking and Power Protected Checking
    [Documentation]    Test to verify the product & rates page for new deposit accounts: power checking & power protected checking
    [Tags]    new_test
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}

    Click On    Ribbon_Accounts
    Click On    LeftNav_OpenNewAccounts
    Click On    LeftNav_OpenNewAccounts_DepositAccounts
    select kendo dropdown    OpenNewAccounts_ProductTypeList    Checking
    #assert page contains    Security Service Power Protected Checking Rates
    # checking rates table

    Exists    Rates_Table_PPC
    capture page screenshot

    ${row} =    Get Table Row Count    Rates_Table_PPC
    Expect Text In Table Cell    Rates_Table_PPC    1    1    Balance Tier
    Expect Text In Table Cell    Rates_Table_PPC    1    2    Dividend Rate
    Expect Text In Table Cell    Rates_Table_PPC    2    1    $0.00 - $9,999.99
    Expect Text In Table Cell    Rates_Table_PPC    2    2    .05%
    Expect Text In Table Cell    Rates_Table_PPC    3    1    $10,000 - $24,999.99
    Expect Text In Table Cell    Rates_Table_PPC    3    2    .40%
    Expect Text In Table Cell    Rates_Table_PPC    4    1    $25,000 - $49,999.99
    Expect Text In Table Cell    Rates_Table_PPC    4    2    .40%
    Expect Text In Table Cell    Rates_Table_PPC    5    1    $50,000 - $99,999.99
    Expect Text In Table Cell    Rates_Table_PPC    5    2    .50%
    Expect Text In Table Cell    Rates_Table_PPC    6    1    $100,000 +
    Expect Text In Table Cell    Rates_Table_PPC    6    2    .50%

    Execute Javascript	window.scrollTo(0,document.body.scrollHeight);
    # if above dont work, implement any of the below to scroll element into view
    #Execute Javascript	window.scrollTo(2635,893);
    #scroll to element
    #scroll page to view
    #Go to	https://www.ssfcu.org/SiteCollectionDocuments/application-disclosures/truthinsavings.pdf
    #scroll page to location    2635    893

    capture page screenshot

    [Teardown]    Log Out myBranch

Open New Accounts - Apply for a Credit Card - Security Service Power Cash Back World MasterCard - Verify URL
    [Documentation]    Test to verify the link appear for Security Service Power Cash Back World MasterCard(Validate the URL)
    [Tags]    new_test
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}

    Click On    Ribbon_Accounts
    Click On    LeftNav_OpenNewAccounts
    Click On    LeftNav_OpenNewAccounts_Loans
    Exists    Power_Cash_Back_World_MasterCard_URL
    capture page screenshot
    click on    Power_Cash_Back_World_MasterCard_URL
    Register Window
    location should contain    https://www.ssfcu.org/en-us/apps/pages/profile/signin.aspx
    Capture Page Screenshot
    Close Window
    Unregister Window

    [Teardown]    Log Out myBranch
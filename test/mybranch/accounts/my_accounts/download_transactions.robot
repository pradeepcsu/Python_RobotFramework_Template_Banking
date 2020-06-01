*** Settings ***
Library           Selenium2Library
Library           Screenshot
Library           MyBranch
Library           Host
Resource          ../../mybranch_keywords.robot

*** Test Cases ***
Download Transactions for CD Account
    [Documentation]    UFT test case: 'Accounts - Download Transactions - CD'
    [Tags]    qa_suite    uat2_suite
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}
    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_DownloadTransactions
    Select Aria List Item    DownloadTransactions_Account    ${account_namenumber}
    ${from_date} =    Get Date    days_modify=-356
    ${to_date} =    Get Date    days_modify=-3
    Enter Text    Download_FromDate    ${from_date}
    Enter Text    Download_ToDate    ${to_date}
    Select Aria List Item    Download_Format    Comma Separated (.CSV)
    Exists    DownloadTransactions_Download
    [Teardown]    Log Out myBranch

Download Transactions - From Date Blank
    [Documentation]    UFT test case: 'Accounts - Download Transactions - FromDate-Blank'
    [Tags]    qa_suite    negative_test
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}
    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_DownloadTransactions
    Select Aria List Item    DownloadTransactions_Account    ${account_namenumber}
    Enter Text    Download_FromDate    ${EMPTY}
    Select Aria List Item    Download_Format    Comma Separated (.CSV)
    Click On    DownloadTransactions_Download
    Assert Page Contains    Please enter a start date.
    [Teardown]    Log Out myBranch

Download Transactions - From Date is Future Date
    [Documentation]    UFT test case: 'Accounts - Download Transactions - FromDate-FutureDay'
    [Tags]    qa_suite    negative_test    uat2_suite
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}
    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_DownloadTransactions
    Select Aria List Item    DownloadTransactions_Account    ${account_namenumber}
    ${from_date} =    Get Date    days_modify=100
    Enter Text    Download_FromDate    ${from_date}
    Select Aria List Item    Download_Format    Intuit Quicken (.QFX)
    Click On    DownloadTransactions_Download
    Assert Page Contains    From date cannot be after today's date.
    Assert Page Contains    Start date cannot be after end date.
    [Teardown]    Log Out myBranch

Download Transactions - From Date with Invalid Format
    [Documentation]    UFT test case: 'Accounts - Download Transactions - FromDate-InvalidFormat'
    [Tags]    qa_suite    negative_test    uat2_suite
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}
    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_DownloadTransactions
    Select Aria List Item    DownloadTransactions_Account    ${account_namenumber}
    Enter Text    Download_FromDate    10012010
    Select Aria List Item    Download_Format    Intuit Quicken (.QFX)
    Click On    DownloadTransactions_Download
    Assert Page Contains    Please enter a valid date in mm/dd/yyyy format.
    [Teardown]    Log Out myBranch

Download Transactions - To Date Blank
    [Documentation]    UFT test case: 'Accounts - Download Transactions - ToDate-Blank'
    [Tags]    qa_suite    negative_test    uat2_suite
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}
    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_DownloadTransactions
    Select Aria List Item    DownloadTransactions_Account    ${account_namenumber}
    Enter Text    Download_ToDate    ${EMPTY}
    Select Aria List Item    Download_Format    QuickBooks (.QBO)
    Click On    DownloadTransactions_Download
    Assert Page Contains    Please enter an end date.
    [Teardown]    Log Out myBranch
    
Download Transactions - To Date with Invalid Format
    [Documentation]    UFT test case: 'Account Details - CD'
    [Tags]    qa_suite    negative_test
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}
    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_DownloadTransactions
    Select Aria List Item    DownloadTransactions_Account    ${account_namenumber}

    Enter Text    Download_ToDate    121780/34
    Select Aria List Item    Download_Format    Intuit Quicken (.QFX)
    Click On    DownloadTransactions_Download
    Assert Page Contains    Please enter a valid date in mm/dd/yyyy format.
    
    [Teardown]    Log Out myBranch

Download Transactions - Verify Default 30 Days Range
    [Documentation]    UFT test case: 'Accounts - Account Details - Verify Default 30 Days Date Range'
    [Tags]    qa_suite    uat2_suite
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}
    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_DownloadTransactions
    ${from_date} =    Get Date    days_modify=-30
    ${to_date} =    Get Date
    Expect Date    Download_FromDate    ${from_date}
    Expect Date    Download_ToDate    ${to_date}
    [Teardown]    Log Out myBranch
    
Download Transactions - Max Characters in To Date
    [Documentation]    UFT test case: 'Accounts - Download Transactions - ToDate-MaxChar'
    [Tags]    qa_suite    negative_test    uat2_suite
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}
    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_DownloadTransactions
    Select Aria List Item    DownloadTransactions_Account    ${account_namenumber}
    Enter Text    Download_ToDate    01/21/20172011
    Select Aria List Item    Download_Format    Intuit Quicken (.QFX)
    Click On    DownloadTransactions_Download
    Assert Page Contains    Please enter a valid date in mm/dd/yyyy format.    
    [Teardown]    Log Out myBranch
    
Download Transactions - Max Characters in From Date
    [Documentation]    UFT test case: 'Accounts - Download Transactions - FromDate-MaxChar'   
    [Tags]    qa_suite    negative_test
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}
    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_DownloadTransactions
    Select Aria List Item    DownloadTransactions_Account    ${account_namenumber}
    Enter Text    Download_FromDate    12120162617
    Select Aria List Item    Download_Format    Intuit Quicken (.QFX)
    Click On    DownloadTransactions_Download
    Assert Page Contains    Please enter a valid date in mm/dd/yyyy format.     
    [Teardown]    Log Out myBranch

Download Transactions for HELOC Account
    [Documentation]    UFT test case: 'Accounts - Download Transactions - ALS-HELOC-2012'
    [Tags]    qa_suite    negative_test    uat2_suite
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}
    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_DownloadTransactions
    ${from_date} =    Get Date    days_modify=-1460
    ${to_date} =    Get Date    days_modify=-0
    Select Aria List Item    DownloadTransactions_Account    ${account_namenumber}
    Enter Text    Download_FromDate    ${from_date}
    Enter Text    Download_ToDate    ${to_date}
    Select Aria List Item    Download_Format    Intuit Quicken (.QFX)
    [Teardown]    Log Out myBranch

Download Transactions for IRA Account
    [Documentation]    UFT test case: 'Accounts - Download Transactions - IRA-2012'
    [Tags]    qa_suite    negative_test
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}
    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_DownloadTransactions
    ${from_date} =    Get Date    days_modify=-1460
    ${to_date} =    Get Date    days_modify=-0
    Select Aria List Item    DownloadTransactions_Account    ${account_namenumber}
    Enter Text    Download_FromDate    ${from_date}
    Enter Text    Download_ToDate    ${to_date}
    Select Aria List Item    Download_Format    QuickBooks (.QBO)
    [Teardown]    Log Out myBranch

Download Transactions for Loan Account
    [Documentation]    UFT test case: 'Accounts - Download Transactions - Loan-2012'
    [Tags]    qa_suite    negative_test
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}
    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_DownloadTransactions
    ${from_date} =    Get Date    days_modify=-1460
    ${to_date} =    Get Date    days_modify=-0
    Select Aria List Item    DownloadTransactions_Account    ${account_namenumber}
    Enter Text    Download_FromDate    ${from_date}
    Enter Text    Download_ToDate    ${to_date}
    Select Aria List Item    Download_Format    Comma Separated (.CSV)
    [Teardown]    Log Out myBranch

Download Transactions for LOC Account
    [Documentation]    UFT test case: 'Accounts - Download Transactions - LOC'
    [Tags]    qa_suite    negative_test    uat2_suite
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}
    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_DownloadTransactions
    ${from_date} =    Get Date    days_modify=-1460
    ${to_date} =    Get Date    days_modify=-0
    Select Aria List Item    DownloadTransactions_Account    ${account_namenumber}
    Enter Text    Download_FromDate    ${from_date}
    Enter Text    Download_ToDate    ${to_date}
    Select Aria List Item    Download_Format    Intuit Quicken (.QFX)
    [Teardown]    Log Out myBranch

Download Transactions for Savings Account
    [Documentation]    UFT test case: 'Accounts - Download Transactions - Savings'
    [Tags]    qa_suite    negative_test
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}
    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_DownloadTransactions
    ${from_date} =    Get Date    days_modify=-1460
    ${to_date} =    Get Date    days_modify=-0
    Select Aria List Item    DownloadTransactions_Account    ${account_namenumber}
    Enter Text    Download_FromDate    ${from_date}
    Enter Text    Download_ToDate    ${to_date}
    Select Aria List Item    Download_Format    QuickBooks (.QBO)
    [Teardown]    Log Out myBranch

Download Transactions - To Date is Future Date
    [Documentation]    UFT test case: 'Accounts - Download Transactions - ToDate-FutureDay'
    [Tags]    qa_suite    negative_test
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}
    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_DownloadTransactions
    Select Aria List Item    DownloadTransactions_Account    ${account_namenumber}
    ${to_date} =    Get Date    days_modify=100
    Enter Text    Download_ToDate    ${to_date}
    Select Aria List Item    Download_Format    Comma Separated (.CSV)
    Click On    DownloadTransactions_Download
    Assert Page Contains    End date cannot be a future date.
    [Teardown]    Log Out myBranch



*** Settings ***
Library           Selenium2Library
Library           Screenshot
Library           MyBranch
Library           Host
Resource          ../../mybranch_keywords.robot


*** Test Cases ***
Add and Delete Alert - Transaction - Greater Than, ATM Withdrawal
    [Documentation]
    ...    UFT test case: 'Accounts - Add New Alert - Transaction, Checking,
    ...    ATM Withdrawl, Greater Than - Code 67/68/9'
    [Tags]    qa_suite    uat2_suite    manage_alert
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}
    Go To Add New Alert

    Select Radio Option    AlertTypeID    2  # Transaction
    Select Aria List Item    Alert_Account    ${account_namenumber}
    Select Aria List Item    Alert_TransactionType    ATM Withdrawal
    Select Aria List Item    Alert_Criteria    Greater Than
    Click On    Alert_Amount_d
    Enter Text    Alert_Amount    10
    Click On    Alert_Next
    Expect Text    AddNewAlert_VerifyType    Transaction
    Expect Text    AddNewAlert_VerifyAccount    ${account_namenumber}
    Expect Text    AddNewAlert_VerifyTransaction    ATM Withdrawal
    Expect Text    AddNewAlert_VerifyCriteria    Greater Than
    Expect Text    AddNewAlert_VerifyThreshold    $10
    Expect Text    AddNewAlert_VerifyContacts    Primary Member
    Click On    Alert_Save
    Assert Page Contains    Your New Alert has been created.
    Click On    Alert_Close
    ${row} =    Get Table Row Count    Alerts_Table
    Expect Text In Table Cell    Alerts_Table    ${row}    2    Transaction
    Expect Text In Table Cell    Alerts_Table    ${row}    3    Send alert for ATM Withdrawal Greater Than $10.00 on ${account_namenumber}.
    Expect Text In Table Cell    Alerts_Table    ${row}    4    Primary Member
    Click Delete Alert    ${row}
    Click On    DeleteAlert_Delete
    Click On    DeleteAlert_Close
    [Teardown]    Log Out myBranch

Add and Delete Alert - Transaction - Less Than, ATM Withdrawal
    [Documentation]
    ...    UFT test case: 'Accounts - Add New Alert - Transaction, Checking,
    ...    ATM Withdrawl, Less Than - Code 67/68/9'
    [Tags]    qa_suite    manage_alert
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}
    Go To Add New Alert

    Select Radio Option    AlertTypeID    2  # Transaction
    Select Aria List Item    Alert_Account    ${account_namenumber}
    Select Aria List Item    Alert_TransactionType    ATM Withdrawal
    Select Aria List Item    Alert_Criteria    Less Than
    Click On    Alert_Amount_d
    Enter Text    Alert_Amount    10
    Click On    Alert_Next
    Expect Text    AddNewAlert_VerifyType    Transaction
    Expect Text    AddNewAlert_VerifyAccount    ${account_namenumber}
    Expect Text    AddNewAlert_VerifyTransaction    ATM Withdrawal
    Expect Text    AddNewAlert_VerifyCriteria    Less Than
    Expect Text    AddNewAlert_VerifyThreshold    $10
    Expect Text    AddNewAlert_VerifyContacts    Primary Member
    Click On    Alert_Save
    Assert Page Contains    Your New Alert has been created.
    Click On    Alert_Close
    ${row} =    Get Table Row Count    Alerts_Table
    Expect Text In Table Cell    Alerts_Table    ${row}    2    Transaction
    Expect Text In Table Cell    Alerts_Table    ${row}    3    Send alert for ATM Withdrawal Less Than $10.00 on ${account_namenumber}.
    Expect Text In Table Cell    Alerts_Table    ${row}    4    Primary Member
    Click Delete Alert    ${row}
    Click On    DeleteAlert_Delete
    Click On    DeleteAlert_Close
    [Teardown]    Log Out myBranch

Add and Delete Alert - New Message
    [Documentation]
    ...    UFT test case: 'Accounts - Alerts - NewMessage'
    [Tags]    qa_suite    uat2_suite    manage_alert
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}
    Go To Add New Alert

    Select Radio Option    AlertTypeID    3  # New Message
    Click On    Alert_Next
    Expect Text    AddNewAlert_VerifyType    New Message
    Expect Text    AddNewAlert_VerifyContacts    Primary Member
    Click On    Alert_Save
    Assert Page Contains    Your New Alert has been created.
    Click On    Alert_Close
    ${row} =    Get Table Row Count    Alerts_Table
    Expect Text In Table Cell    Alerts_Table    ${row}    2    New Message
    Expect Text In Table Cell    Alerts_Table    ${row}    3    Send alert indicating new Secure Message(s) available.
    Expect Text In Table Cell    Alerts_Table    ${row}    4    Primary Member
    Click Delete Alert    ${row}
    Click On    DeleteAlert_Delete
    Click On    DeleteAlert_Close
    [Teardown]    Log Out myBranch

Add and Delete Alert - Transaction - Greater Than, Electronic Deposit
    [Documentation]
    ...    UFT test case: 'Accounts - Add New Alert - Transaction, Checking,
    ...    Electronic Deposit, Greater Than - Code 22 - Code 22/32'
    [Tags]    qa_suite    manage_alert
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}
    Go To Add New Alert
    Select Radio Option    AlertTypeID    2  # Transaction
    Select Aria List Item    Alert_Account    ${account_namenumber}
    Select Aria List Item    Alert_TransactionType    Electronic Deposit
    Select Aria List Item    Alert_Criteria    Greater Than
    Click On    Alert_Amount_d
    Enter Text    Alert_Amount    10
    Click On    Alert_Next
    Expect Text    AddNewAlert_VerifyType    Transaction
    Expect Text    AddNewAlert_VerifyAccount    ${account_namenumber}
    Expect Text    AddNewAlert_VerifyTransaction    Electronic Deposit
    Expect Text    AddNewAlert_VerifyCriteria    Greater Than
    Expect Text    AddNewAlert_VerifyThreshold    $10
    Expect Text    AddNewAlert_VerifyContacts    Primary Member
    Click On    Alert_Save
    Assert Page Contains    Your New Alert has been created.
    Click On    Alert_Close
    ${row} =    Get Table Row Count    Alerts_Table
    Expect Text In Table Cell    Alerts_Table    ${row}    2    Transaction
    Expect Text In Table Cell    Alerts_Table    ${row}    3    Send alert for Electronic Deposit Greater Than $10.00 on ${account_namenumber}.
    Expect Text In Table Cell    Alerts_Table    ${row}    4    Primary Member
    Click Delete Alert    ${row}
    Click On    DeleteAlert_Delete
    Click On    DeleteAlert_Close
    [Teardown]    Log Out myBranch

Add and Delete Alert - Transaction - Less Than, Electronic Deposit
   [Documentation]
    ...    UFT test case: 'Accounts - Add New Alert - Transaction, Checking,
    ...    Electronic Deposit, Less Than - Code 22 - Code 22/32'
    [Tags]    qa_suite    uat2_chrome    manage_alert
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}
    Go To Add New Alert
    Select Radio Option    AlertTypeID    2  # Transaction
    Select Aria List Item    Alert_Account    ${account_namenumber}
    Select Aria List Item    Alert_TransactionType    Electronic Deposit
    Select Aria List Item    Alert_Criteria    Less Than
    Click On    Alert_Amount_d
    Enter Text    Alert_Amount    10
    Click On    Alert_Next
    Expect Text    AddNewAlert_VerifyType    Transaction
    Expect Text    AddNewAlert_VerifyAccount    ${account_namenumber}
    Expect Text    AddNewAlert_VerifyTransaction    Electronic Deposit
    Expect Text    AddNewAlert_VerifyCriteria    Less Than
    Expect Text    AddNewAlert_VerifyThreshold    $10
    Expect Text    AddNewAlert_VerifyContacts    Primary Member
    Click On    Alert_Save
    Assert Page Contains    Your New Alert has been created.
    Click On    Alert_Close
    ${row} =    Get Table Row Count    Alerts_Table
    Expect Text In Table Cell    Alerts_Table    ${row}    2    Transaction
    Expect Text In Table Cell    Alerts_Table    ${row}    3    Send alert for Electronic Deposit Less Than $10.00 on ${account_namenumber}.
    Expect Text In Table Cell    Alerts_Table    ${row}    4    Primary Member
    Click Delete Alert    ${row}
    Click On    DeleteAlert_Delete
    Click On    DeleteAlert_Close
    [Teardown]    Log Out myBranch

Add and Delete Alert - Transaction - Greater Than, Electronic Withdrawl
    [Documentation]
    ...    UFT test case: 'Accounts - Add New Alert - Transaction, Checking,
    ...    Electronic Withdrawl, Grater Than - Code 26 - Code 26/27'
    [Tags]    qa_suite    manage_alert
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}
    Go To Add New Alert
    Select Radio Option    AlertTypeID    2  # Transaction
    Select Aria List Item    Alert_Account    ${account_namenumber}
    Select Aria List Item    Alert_TransactionType    Electronic Withdrawal
    Select Aria List Item    Alert_Criteria    Greater Than
    Click On    Alert_Amount_d
    Enter Text    Alert_Amount    10
    Click On    Alert_Next
    Expect Text    AddNewAlert_VerifyType    Transaction
    Expect Text    AddNewAlert_VerifyAccount    ${account_namenumber}
    Expect Text    AddNewAlert_VerifyTransaction    Electronic Withdrawal
    Expect Text    AddNewAlert_VerifyCriteria    Greater Than
    Expect Text    AddNewAlert_VerifyThreshold    $10
    Expect Text    AddNewAlert_VerifyContacts    Primary Member
    Click On    Alert_Save
    Assert Page Contains    Your New Alert has been created.
    Click On    Alert_Close
    ${row} =    Get Table Row Count    Alerts_Table
    Expect Text In Table Cell    Alerts_Table    ${row}    2    Transaction
    Expect Text In Table Cell    Alerts_Table    ${row}    3    Send alert for Electronic Withdrawal Greater Than $10.00 on ${account_namenumber}.
    Expect Text In Table Cell    Alerts_Table    ${row}    4    Primary Member
    Click Delete Alert    ${row}
    Click On    DeleteAlert_Delete
    Click On    DeleteAlert_Close
    [Teardown]    Log Out myBranch

Add and Delete Alert - Transaction - Less Than, Electronic Withdrawl
   [Documentation]
    ...    UFT test case: 'Accounts - Add New Alert - Transaction, Checking,
    ...    Electronic Withdrawl, Less Than - Code 26 - Code 26/27'
    [Tags]    qa_suite    manage_alert
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}
    Go To Add New Alert
    Select Radio Option    AlertTypeID    2  # Transaction
    Select Aria List Item    Alert_Account    ${account_namenumber}
    Select Aria List Item    Alert_TransactionType    Electronic Withdrawal
    Select Aria List Item    Alert_Criteria    Less Than
    Click On    Alert_Amount_d
    Enter Text    Alert_Amount    10
    Click On    Alert_Next
    Expect Text    AddNewAlert_VerifyType    Transaction
    Expect Text    AddNewAlert_VerifyAccount    ${account_namenumber}
    Expect Text    AddNewAlert_VerifyTransaction    Electronic Withdrawal
    Expect Text    AddNewAlert_VerifyCriteria    Less Than
    Expect Text    AddNewAlert_VerifyThreshold    $10
    Expect Text    AddNewAlert_VerifyContacts    Primary Member
    Click On    Alert_Save
    Assert Page Contains    Your New Alert has been created.
    Click On    Alert_Close
    ${row} =    Get Table Row Count    Alerts_Table
    Expect Text In Table Cell    Alerts_Table    ${row}    2    Transaction
    Expect Text In Table Cell    Alerts_Table    ${row}    3    Send alert for Electronic Withdrawal Less Than $10.00 on ${account_namenumber}.
    Expect Text In Table Cell    Alerts_Table    ${row}    4    Primary Member
    Click Delete Alert    ${row}
    Click On    DeleteAlert_Delete
    Click On    DeleteAlert_Close
    [Teardown]    Log Out myBranch

Add and Delete Alert - Transaction - Greater Than, Debit Card Purchase
    [Documentation]
    ...    UFT test case: 'Accounts - Alert - Transaction - Balance'
    [Tags]    qa_suite    manage_alert
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}
    Go To Add New Alert
    Select Radio Option    AlertTypeID    2  # Transaction
    Select Aria List Item    Alert_Account    ${account_namenumber}
    Select Aria List Item    Alert_TransactionType    Debit Card Purchase
    Select Aria List Item    Alert_Criteria    Greater Than
    Click On    Alert_Amount_d
    Enter Text    Alert_Amount    10
    Click On    Alert_Next
    Expect Text    AddNewAlert_VerifyType    Transaction
    Expect Text    AddNewAlert_VerifyAccount    ${account_namenumber}
    Expect Text    AddNewAlert_VerifyTransaction    Debit Card Purchase
    Expect Text    AddNewAlert_VerifyCriteria    Greater Than
    Expect Text    AddNewAlert_VerifyThreshold    $10
    Expect Text    AddNewAlert_VerifyContacts    Primary Member
    Click On    Alert_Save
    Assert Page Contains    Your New Alert has been created.
    Click On    Alert_Close
    ${row} =    Get Table Row Count    Alerts_Table
    Expect Text In Table Cell    Alerts_Table    ${row}    2    Transaction
    Expect Text In Table Cell    Alerts_Table    ${row}    3    Send alert for Debit Card Purchase Greater Than $10.00 on ${account_namenumber}.
    Expect Text In Table Cell    Alerts_Table    ${row}    4    Primary Member
    Click Delete Alert    ${row}
    Click On    DeleteAlert_Delete
    Click On    DeleteAlert_Close
    [Teardown]    Log Out myBranch

Add and Delete Alert - Transaction - Less Than, Debit Card Purchase
    [Documentation]
    ...    UFT test case: 'Accounts - Alerts - Transaction - Balance - LessThan'
    [Tags]    qa_suite    uat2_suite    manage_alert
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}
    Go To Add New Alert
    Select Radio Option    AlertTypeID    2  # Transaction
    Select Aria List Item    Alert_Account    ${account_namenumber}
    Select Aria List Item    Alert_TransactionType    Debit Card Purchase
    Select Aria List Item    Alert_Criteria    Less Than
    Click On    Alert_Amount_d
    Enter Text    Alert_Amount    10
    Click On    Alert_Next
    Expect Text    AddNewAlert_VerifyType    Transaction
    Expect Text    AddNewAlert_VerifyAccount    ${account_namenumber}
    Expect Text    AddNewAlert_VerifyTransaction    Debit Card Purchase
    Expect Text    AddNewAlert_VerifyCriteria    Less Than
    Expect Text    AddNewAlert_VerifyThreshold    $10
    Expect Text    AddNewAlert_VerifyContacts    Primary Member
    Click On    Alert_Save
    Assert Page Contains    Your New Alert has been created.
    Click On    Alert_Close
    ${row} =    Get Table Row Count    Alerts_Table
    Expect Text In Table Cell    Alerts_Table    ${row}    2    Transaction
    Expect Text In Table Cell    Alerts_Table    ${row}    3    Send alert for Debit Card Purchase Less Than $10.00 on ${account_namenumber}.
    Expect Text In Table Cell    Alerts_Table    ${row}    4    Primary Member
    Click Delete Alert    ${row}
    Click On    DeleteAlert_Delete
    Click On    DeleteAlert_Close
    [Teardown]    Log Out myBranch





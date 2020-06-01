*** Settings ***
Library           Selenium2Library
Library           Screenshot
Library           MyBranch
Library           Host
Resource          ../mybranch_keywords.robot


*** Test Cases ***
Request Official Check
    [Documentation]    UFT test: "Support - Account Inquiries - RequestOfficialCheck"
    [Tags]    qa_suite    uat2_suite    support
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Load Browser
    Log In myBranch    ${username}    ${password}
    Click On    Ribbon_Support
    Click On    LeftNav_Support_RequestOfficialCheck

    Assert Page Contains    Request Official Check
    Select Aria List Item    Support_RequestOfficialCheck_Account    ${account_namenumber}
    Enter Aria Text    Support_RequestOfficialCheck_CheckAmount    1.00
    Enter Text    Support_RequestOfficialCheck_PayeeName    Joe
    Enter Text    Support_RequestOfficialCheck_PayeeAccountReferenceNumber    1234
    Enter Text    Support_RequestOfficialCheck_PayeeAddress    1234 meadow creek
    Enter Text    Support_RequestOfficialCheck_PayeeCity    San Antonio
    Select Aria List Item    Support_RequestOfficialCheck_PayeeState    TX - Texas
    Enter Text    Support_RequestOfficialCheck_PayeeZipCode    78249
    Enter Text    Support_RequestOfficialCheck_PayeePhoneNumber    (210) 210-2100
    Capture Page Screenshot

    Click On    Support_RequestOfficialCheck_NextButton
    Capture Page Screenshot

    Expect Text Contains    Support_PayeeDetails_Account    ${account_namenumber}
    Expect Text Contains    Support_PayeeDetails_Amount    $1.00
    Expect Text Contains    Support_PayeeDetails_Name    joe
    Expect Text Contains    Support_PayeeDetails_RefNo    1234
    Expect Text Contains    Support_PayeeDetails_Address    1234 meadow creek
    Expect Text Contains    Support_PayeeDetails_City    San Antonio
    Expect Text Contains    Support_PayeeDetails_State    TX - Texas
    Expect Text Contains    Support_PayeeDetails_Zip    78249
    Expect Text Contains    Support_PayeeDetails_Phone    (210) 210-2100

    Click On    Support_RequestOfficialCheck_SubmitButton
    Capture Page Screenshot

    Assert Page Contains    Official Check Request Complete
    Assert Page Contains    Your Official Check Request has been submitted
    Capture Page Screenshot

    [Teardown]    Log Out myBranch

RequestOfficialCheck - Amount - Blank
    [Documentation]    UFT test: "Support - Account Inquiries - RequestOfficialCheck - Amount - Blank"
    [Tags]    qa_suite    support
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Load Browser
    Log In myBranch    ${username}    ${password}
    Click On    Ribbon_Support
    Click On    LeftNav_Support_RequestOfficialCheck

    Assert Page Contains    Request Official Check
    Select Aria List Item    Support_RequestOfficialCheck_Account    ${account_namenumber}
    Enter Text    Support_RequestOfficialCheck_PayeeName    Joe
    Enter Text    Support_RequestOfficialCheck_PayeeAccountReferenceNumber    1234
    Enter Text    Support_RequestOfficialCheck_PayeeAddress    1234 meadow creek
    Enter Text    Support_RequestOfficialCheck_PayeeCity    San Antonio
    Select Aria List Item    Support_RequestOfficialCheck_PayeeState    TX - Texas
    Enter Text    Support_RequestOfficialCheck_PayeeZipCode    78249
    Enter Text    Support_RequestOfficialCheck_PayeePhoneNumber    (210) 210-2100
    Capture Page Screenshot

    Click On    Support_RequestOfficialCheck_NextButton
    Capture Page Screenshot

    Exists    Support_CheckAmountError
    Expect Text Contains    Support_CheckAmountError    Please enter an Amount

    [Teardown]    Log Out myBranch

RequestOfficialCheck - Amount - Zero
    [Documentation]    UFT test: "Support - Account Inquiries - RequestOfficialCheck - Amount - Zero"
    [Tags]    qa_suite    support
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Load Browser
    Log In myBranch    ${username}    ${password}
    Click On    Ribbon_Support
    Click On    LeftNav_Support_RequestOfficialCheck

    Assert Page Contains    Request Official Check
    Select Aria List Item    Support_RequestOfficialCheck_Account    ${account_namenumber}
    Enter Aria Text    Support_RequestOfficialCheck_CheckAmount    $0.00
    Enter Text    Support_RequestOfficialCheck_PayeeName    Joe
    Enter Text    Support_RequestOfficialCheck_PayeeAccountReferenceNumber    1234
    Enter Text    Support_RequestOfficialCheck_PayeeAddress    1234 meadow creek
    Enter Text    Support_RequestOfficialCheck_PayeeCity    San Antonio
    Select Aria List Item    Support_RequestOfficialCheck_PayeeState    TX - Texas
    Enter Text    Support_RequestOfficialCheck_PayeeZipCode    78249
    Enter Text    Support_RequestOfficialCheck_PayeePhoneNumber    (210) 210-2100
    Capture Page Screenshot

    Click On    Support_RequestOfficialCheck_NextButton
    Capture Page Screenshot

    Exists    Support_CheckAmountError
    Expect Text Contains    Support_CheckAmountError    Please enter an amount greater than $0 and no more than $99,999,999.00

    [Teardown]    Log Out myBranch

RequestOfficialCheck - Amount - MaxChar
    [Documentation]    UFT test: "Support - Account Inquiries - RequestOfficialCheck - Amount - MaxChar"
    [Tags]    qa_suite    support
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Load Browser
    Log In myBranch    ${username}    ${password}
    Click On    Ribbon_Support
    Click On    LeftNav_Support_RequestOfficialCheck

    Assert Page Contains    Request Official Check
    Select Aria List Item    Support_RequestOfficialCheck_Account    ${account_namenumber}
    Enter Aria Text    Support_RequestOfficialCheck_CheckAmount    111111111
    Enter Text    Support_RequestOfficialCheck_PayeeName    Joe
    Enter Text    Support_RequestOfficialCheck_PayeeAccountReferenceNumber    1234
    Enter Text    Support_RequestOfficialCheck_PayeeAddress    1234 meadow creek
    Enter Text    Support_RequestOfficialCheck_PayeeCity    San Antonio
    Select Aria List Item    Support_RequestOfficialCheck_PayeeState    TX - Texas
    Enter Text    Support_RequestOfficialCheck_PayeeZipCode    78249
    Enter Text    Support_RequestOfficialCheck_PayeePhoneNumber    (210) 210-2100
    Capture Page Screenshot

    Click On    Support_RequestOfficialCheck_NextButton
    Capture Page Screenshot

    Exists    Support_CheckAmountError
    Expect Text Contains    Support_CheckAmountError    Please enter an amount greater than $0 and no more than $99,999,999.00

    [Teardown]    Log Out myBranch

RequestOfficialCheck - Amount - SpecChar
    [Documentation]    UFT test: "Support - Account Inquiries - RequestOfficialCheck - Amount - SpecChar"
    [Tags]    qa_suite    uat2_suite    support
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Load Browser
    Log In myBranch    ${username}    ${password}
    Click On    Ribbon_Support
    Click On    LeftNav_Support_RequestOfficialCheck

    Assert Page Contains    Request Official Check
    Select Aria List Item    Support_RequestOfficialCheck_Account    ${account_namenumber}
    Enter Aria Text    Support_RequestOfficialCheck_CheckAmount    ?2
    Enter Text    Support_RequestOfficialCheck_PayeeName    Joe
    Expect Text    Support_RequestOfficialCheck_CheckAmount    2

    Capture Page Screenshot

    [Teardown]    Log Out myBranch

RequestOfficialCheck - Amount - Alpha
    [Documentation]    UFT test: "Support - Account Inquiries - RequestOfficialCheck_Amount_Alpha"
    [Tags]    qa_suite    support
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    #Load Browser
    Log In myBranch    ${username}    ${password}
    Click On    Ribbon_Support
    Click On    LeftNav_Support_RequestOfficialCheck

    Assert Page Contains    Request Official Check
    Select Aria List Item    Support_RequestOfficialCheck_Account    ${account_namenumber}
    Enter Aria Text    Support_RequestOfficialCheck_CheckAmount    @2
    Enter Text    Support_RequestOfficialCheck_PayeeName    Joe
    Expect Text    Support_RequestOfficialCheck_CheckAmount    2

    Capture Page Screenshot

    [Teardown]    Log Out myBranch

RequestOfficialCheck - Account - Blank
    [Documentation]    UFT test: "Support - Account Inquiries - RequestOfficialCheck - Blank"
    [Tags]    qa_suite    support
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Load Browser
    Log In myBranch    ${username}    ${password}
    Click On    Ribbon_Support
    Click On    LeftNav_Support_RequestOfficialCheck

    Assert Page Contains    Request Official Check
    Enter Aria Text    Support_RequestOfficialCheck_CheckAmount    1
    Enter Text    Support_RequestOfficialCheck_PayeeName    Joe
    Enter Text    Support_RequestOfficialCheck_PayeeAccountReferenceNumber    1234
    Enter Text    Support_RequestOfficialCheck_PayeeAddress    1234 meadow creek
    Enter Text    Support_RequestOfficialCheck_PayeeCity    San Antonio
    Select Aria List Item    Support_RequestOfficialCheck_PayeeState    TX - Texas
    Enter Text    Support_RequestOfficialCheck_PayeeZipCode    78249
    Enter Text    Support_RequestOfficialCheck_PayeePhoneNumber    (210) 210-2100
    Capture Page Screenshot

    Click On    Support_RequestOfficialCheck_NextButton
    Capture Page Screenshot

    Exists    Support_AccountSelectionError
    Expect Text Contains    Support_AccountSelectionError    Please select an Account

    [Teardown]    Log Out myBranch

RequestStopPayment
    [Documentation]    UFT test: "Support - Account Inquiries - RequestStopPayment"
    [Tags]    qa_suite    uat2_suite    support    support_prebatch
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Load Browser
    Log In myBranch    ${username}    ${password}
    Click On    Ribbon_Support
    Click On    LeftNav_Support_RequestStopPayment
    Assert Page Contains    Request Stop Payment

    Click On    Support_RequestStopPayment_RequestStopPaymentButton

    Select Aria List Item    Support_RequestStopPayment_StopPaymentOn    Single Check
    Select Aria List Item    Support_RequestStopPayment_Account    ${account_namenumber}
    Enter Aria Text    Support_RequestStopPayment_CheckNo    6000
    Enter Aria Text    Support_RequestStopPayment_Amount    2000
    Enter Text    Support_RequestStopPayment_Payee    Joe

    Click On    Support_RequestStopPayment_NextButton
    Capture Page Screenshot

    Assert Page Contains    Request Stop Payment
    Assert Page Contains    ​Please review information for accuracy, then click Submit.

    Expect Text Contains    Support_RequestStopPayment_Confirmation_SingleAccount    ${account_namenumber}
    Expect Text Contains    Support_RequestStopPayment_Confirmation_SingleCheckNo    6000
    Expect Text Contains    Support_RequestStopPayment_Confirmation_SingleAmount    $2,000.00
    Expect Text Contains    Support_RequestStopPayment_Confirmation_SinglePayee    Joe

    Click On    Support_RequestStopPayment_EditButton

    ${Check_No} =     Get Random Number
    Log    ${Check_No}

    Enter Aria Text    Support_RequestStopPayment_CheckNo    ${Check_No}
    Enter Aria Text    Support_RequestStopPayment_Amount    4000
    Enter Text    Support_RequestStopPayment_Payee    Bill

    Click On    Support_RequestStopPayment_NextButton
    Capture Page Screenshot

    Expect Text Contains    Support_RequestStopPayment_Confirmation_SingleAccount    ${account_namenumber}
    Expect Text Contains    Support_RequestStopPayment_Confirmation_SingleCheckNo    ${Check_No}
    Expect Text Contains    Support_RequestStopPayment_Confirmation_SingleAmount    $4,000.00
    Expect Text Contains    Support_RequestStopPayment_Confirmation_SinglePayee    Bill

    Click On    Support_RequestStopPayment_SubmitButton
    Sleep    3
    Capture Page Screenshot

    Click On    Support_RequestStopPaymentRange_CloseButton
    Sleep    2
    Click On    LeftNav_Support_RequestStopPayment
    Assert Page Contains    Request Stop Payment

    #${List} =     check exists    Support_RequestStopPaymentRange_SelectAccount
    ${List} =     exists    Support_RequestStopPaymentRange_SelectAccount

    Log    ${List}
    Run Keyword If    ${List} == ${True}    Select Aria List Item    Support_RequestStopPaymentRange_SelectAccount    ${account_namenumber}
    Sleep    3
    Capture Page Screenshot

    ${row_count} =    Get Table Row Count    RequestStopPayment_TransactionsTable
    log    ${row_count}
    ${row} =     Evaluate    ${row_count} - 1
    log    ${row}

    Open TSSO
    Go To Account Screen    ${account_number}    imi1
    print host object value    imi1_StopPay

    Go To Account Screen    ${account_number}    imi5
    take screenshot
    Verify request Stop Payment Single Check Against Host
    Capture Page Screenshot
    take screenshot

    save batch    imi1_StopPay    Check_No    account_namenumber    row
    log    ${Check_No}
    log    ${account_namenumber}

    [Teardown]    Log Out myBranch

RequestStopPayment - Issued In Error
    [Documentation]    UFT test: "Support - Account Inquiries - RequestStopPayment - IssuedInError"
    [Tags]    qa_suite    support    support_prebatch
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Load Browser
    Log In myBranch    ${username}    ${password}
    Click On    Ribbon_Support
    Click On    LeftNav_Support_RequestStopPayment
    Assert Page Contains    Request Stop Payment

    Click On    Support_RequestStopPayment_RequestStopPaymentButton
    Select Aria List Item    Support_RequestStopPayment_StopPaymentOn    Check Range/Series
    Select Aria List Item    Support_RequestStopPaymentRange_MultiAccount    ${account_namenumber}
    Enter Aria Text    Support_RequestStopPaymentRange_StartingCheck    700
    Enter Aria Text    Support_RequestStopPaymentRange_EndingCheck    706
    Select Aria List Item    Support_RequestStopPaymentRange_ReasonList    Issued in Error

    Click On    Support_RequestStopPayment_NextButton
    Capture Page Screenshot

    Assert Page Contains    Request Stop Payment
    Assert Page Contains    ​Please review information for accuracy, then click Submit.

    Expect Text Contains    Support_RequestStopPaymentRange_Confirmation_MultiAccount    ${account_namenumber}
    Expect Text Contains    Support_RequestStopPaymentRange_Confirmation_CheckRange    700 to 706
    Expect Text Contains    Support_RequestStopPaymentRange_Confirmation_ReasonList    Issued in Error

    Click On    Support_RequestStopPaymentRange_EditButton
    Capture Page Screenshot

    ${Starting_CheckNo} =    Get Random Number
    ${Ending_CheckNo}=    Evaluate    ${${Starting_CheckNo}} + ${1}
    Log    ${Starting_CheckNo}
    Log    ${Ending_CheckNo}

    Enter Aria Text    Support_RequestStopPaymentRange_StartingCheck    ${Starting_CheckNo}
    Enter Aria Text    Support_RequestStopPaymentRange_EndingCheck    ${Ending_CheckNo}

    Click On    Support_RequestStopPayment_NextButton
    Capture Page Screenshot

    Assert Page Contains    Request Stop Payment
    Assert Page Contains    ​Please review information for accuracy, then click Submit.

    Expect Text Contains    Support_RequestStopPaymentRange_Confirmation_MultiAccount    ${account_namenumber}
    Expect Text Contains    Support_RequestStopPaymentRange_Confirmation_CheckRange    ${Starting_CheckNo} to ${Ending_CheckNo}
    Expect Text Contains    Support_RequestStopPaymentRange_Confirmation_ReasonList    Issued in Error

    Click On    Support_RequestStopPaymentRange_SubmitButton
    Sleep    3
    Capture Page Screenshot
    Click On    Support_RequestStopPaymentRange_CloseButton

    Click On    LeftNav_Support_RequestStopPayment
    Assert Page Contains    Request Stop Payment

    ${List} =     exists    Support_RequestStopPaymentRange_SelectAccount
    Log    ${List}
    Run Keyword If    ${List} == ${True}    Select Aria List Item    Support_RequestStopPaymentRange_SelectAccount    ${account_namenumber}
    Sleep    3
    Capture Page Screenshot

    ${row_count} =    Get Table Row Count    RequestStopPayment_TransactionsTable
    log    ${row_count}
    ${row} =     Evaluate    ${row_count} - 1
    log    ${row}

    Open TSSO
    Go To Account Screen    ${account_number}    imi1
    print host object value    imi1_StopPay

    Go To Account Screen    ${account_number}    imi5
    Verify request Stop Payment Against Host
    Capture Page Screenshot

    save batch    imi1_StopPay        account_namenumber    row    row_count    Starting_CheckNo    Ending_CheckNo
    log    ${account_namenumber}

    [Teardown]    Log Out myBranch

RequestStopPayment - Lost Or Stolen
    [Documentation]    UFT test: "Support - Account Inquiries - RequestStopPayment - LostOrStolen"
    [Tags]    qa_suite    uat2_suite    support    support_prebatch
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Load Browser
    Log In myBranch    ${username}    ${password}
    Click On    Ribbon_Support
    Click On    LeftNav_Support_RequestStopPayment
    Assert Page Contains    Request Stop Payment

    Click On    Support_RequestStopPayment_RequestStopPaymentButton
    Select Aria List Item    Support_RequestStopPayment_StopPaymentOn    Check Range/Series
    Select Aria List Item    Support_RequestStopPaymentRange_MultiAccount    ${account_namenumber}
    Enter Aria Text    Support_RequestStopPaymentRange_StartingCheck    700
    Enter Aria Text    Support_RequestStopPaymentRange_EndingCheck    706
    Select Aria List Item    Support_RequestStopPaymentRange_ReasonList    Lost or Stolen

    Click On    Support_RequestStopPayment_NextButton
    Capture Page Screenshot

    Assert Page Contains    Request Stop Payment
    Assert Page Contains    ​Please review information for accuracy, then click Submit.

    Expect Text Contains    Support_RequestStopPaymentRange_Confirmation_MultiAccount    ${account_namenumber}
    Expect Text Contains    Support_RequestStopPaymentRange_Confirmation_CheckRange    700 to 706
    Expect Text Contains    Support_RequestStopPaymentRange_Confirmation_ReasonList    Lost or Stolen

    Click On    Support_RequestStopPaymentRange_EditButton
    Capture Page Screenshot

    ${Starting_CheckNo} =     Get Random Number
    ${Ending_CheckNo}=     Evaluate    ${${Starting_CheckNo}} + ${1}
    Log    ${Starting_CheckNo}
    Log    ${Ending_CheckNo}

    Enter Aria Text    Support_RequestStopPaymentRange_StartingCheck    ${Starting_CheckNo}
    Enter Aria Text    Support_RequestStopPaymentRange_EndingCheck    ${Ending_CheckNo}

    Click On    Support_RequestStopPayment_NextButton
    Capture Page Screenshot

    Assert Page Contains    Request Stop Payment
    Assert Page Contains    ​Please review information for accuracy, then click Submit.

    Expect Text Contains    Support_RequestStopPaymentRange_Confirmation_MultiAccount    ${account_namenumber}
    Expect Text Contains    Support_RequestStopPaymentRange_Confirmation_CheckRange    ${Starting_CheckNo} to ${Ending_CheckNo}
    Expect Text Contains    Support_RequestStopPaymentRange_Confirmation_ReasonList    Lost or Stolen

    Click On    Support_RequestStopPaymentRange_SubmitButton
    Sleep    3
    Capture Page Screenshot
    Click On    Support_RequestStopPaymentRange_CloseButton

    Click On    LeftNav_Support_RequestStopPayment
    Assert Page Contains    Request Stop Payment

    ${List} =     exists    Support_RequestStopPaymentRange_SelectAccount
    Log    ${List}
    Run Keyword If    ${List} == ${True}    Select Aria List Item    Support_RequestStopPaymentRange_SelectAccount    ${account_namenumber}
    Sleep    3
    Capture Page Screenshot

    ${row_count} =    Get Table Row Count    RequestStopPayment_TransactionsTable
    log    ${row_count}
    ${row} =     Evaluate    ${row_count} - 1
    log    ${row}

    Open TSSO
    Go To Account Screen    ${account_number}    imi1
    print host object value    imi1_StopPay

    Go To Account Screen    ${account_number}    imi5
    Verify request Stop Payment Against Host
    Capture Page Screenshot

    save batch    imi1_StopPay        account_namenumber    row    row_count    Starting_CheckNo    Ending_CheckNo
    log    ${account_namenumber}

    [Teardown]    Log Out myBranch

RequestStopPayment - No Zero
    [Documentation]    UFT test: "Support - Account Inquiries - RequestStopPayment - NoZero"
    [Tags]    negative_test    qa_suite    uat2_suite    support
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Load Browser
    Log In myBranch    ${username}    ${password}
    Click On    Ribbon_Support
    Click On    LeftNav_Support_RequestStopPayment
    Assert Page Contains    Request Stop Payment

    Click On    Support_RequestStopPayment_RequestStopPaymentButton
    Select Aria List Item    Support_RequestStopPayment_StopPaymentOn    Single Check
    Select Aria List Item    Support_RequestStopPayment_Account    ${account_namenumber}
    Enter Aria Text    Support_RequestStopPayment_CheckNo    000
    Enter Aria Text    Support_RequestStopPayment_Amount    2000
    Enter Text    Support_RequestStopPayment_Payee    Bill

    Click On    Support_RequestStopPayment_NextButton
    Capture Page Screenshot

    Exists    Support_CheckNoSelectionError
    Expect Text Contains    Support_CheckNoSelectionError    starting check no. cannot be 0.

    Click On    Support_RequestStopPayment_CancelButton

    [Teardown]    Log Out myBranch

RequestStopPayment - Wrong Address
    [Documentation]    UFT test: "Support - Account Inquiries - RequestStopPayment_WrongAddress"
    [Tags]    qa_suite    support    support_prebatch
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Load Browser
    Log In myBranch    ${username}    ${password}
    Click On    Ribbon_Support
    Click On    LeftNav_Support_RequestStopPayment
    Assert Page Contains    Request Stop Payment

    Click On    Support_RequestStopPayment_RequestStopPaymentButton
    Select Aria List Item    Support_RequestStopPayment_StopPaymentOn    Check Range/Series
    Select Aria List Item    Support_RequestStopPaymentRange_MultiAccount    ${account_namenumber}
    Enter Aria Text    Support_RequestStopPaymentRange_StartingCheck    700
    Enter Aria Text    Support_RequestStopPaymentRange_EndingCheck    706
    Select Aria List Item    Support_RequestStopPaymentRange_ReasonList    Wrong Address

    Click On    Support_RequestStopPayment_NextButton
    Capture Page Screenshot

    Assert Page Contains    Request Stop Payment
    Assert Page Contains    ​Please review information for accuracy, then click Submit.

    Expect Text Contains    Support_RequestStopPaymentRange_Confirmation_MultiAccount    ${account_namenumber}
    Expect Text Contains    Support_RequestStopPaymentRange_Confirmation_CheckRange    700 to 706
    Expect Text Contains    Support_RequestStopPaymentRange_Confirmation_ReasonList    Wrong Address

    Click On    Support_RequestStopPaymentRange_EditButton
    Capture Page Screenshot

    ${Starting_CheckNo} =     Get Random Number
    ${Ending_CheckNo}=     Evaluate    ${${Starting_CheckNo}} + ${1}
    Log    ${Starting_CheckNo}
    Log    ${Ending_CheckNo}

    Enter Aria Text    Support_RequestStopPaymentRange_StartingCheck    ${Starting_CheckNo}
    Enter Aria Text    Support_RequestStopPaymentRange_EndingCheck    ${Ending_CheckNo}

    Click On    Support_RequestStopPayment_NextButton
    Capture Page Screenshot

    Assert Page Contains    Request Stop Payment
    Assert Page Contains    ​Please review information for accuracy, then click Submit.

    Expect Text Contains    Support_RequestStopPaymentRange_Confirmation_MultiAccount    ${account_namenumber}
    Expect Text Contains    Support_RequestStopPaymentRange_Confirmation_CheckRange    ${Starting_CheckNo} to ${Ending_CheckNo}
    Expect Text Contains    Support_RequestStopPaymentRange_Confirmation_ReasonList    Wrong Address

    Click On    Support_RequestStopPaymentRange_SubmitButton
    Sleep    3
    Capture Page Screenshot

    Click On    Support_RequestStopPaymentRange_CloseButton
    Click On    LeftNav_Support_RequestStopPayment
    Assert Page Contains    Request Stop Payment

    ${List} =     exists    Support_RequestStopPaymentRange_SelectAccount
    Log    ${List}
    Run Keyword If    ${List} == ${True}    Select Aria List Item    Support_RequestStopPaymentRange_SelectAccount    ${account_namenumber}
    Sleep    3
    Capture Page Screenshot

    ${row_count} =    Get Table Row Count    RequestStopPayment_TransactionsTable
    log    ${row_count}
    ${row} =     Evaluate    ${row_count} - 1
    log    ${row}

    Open TSSO
    Go To Account Screen    ${account_number}    imi1
    print host object value    imi1_StopPay

    Go To Account Screen    ${account_number}    imi5
    Verify request Stop Payment Against Host

    save batch    imi1_StopPay    account_namenumber    row    row_count    Starting_CheckNo    Ending_CheckNo
    log    ${account_namenumber}

    [Teardown]    Log Out myBranch

RequestStopPayment - Range
    [Documentation]    UFT test: "Support - Account Inquiries - RequestStopPaymentRange"
    [Tags]    qa_suite    support    support_prebatch
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Load Browser
    Log In myBranch    ${username}    ${password}
    Click On    Ribbon_Support
    Click On    LeftNav_Support_RequestStopPayment
    Assert Page Contains    Request Stop Payment

    Click On    Support_RequestStopPayment_RequestStopPaymentButton
    Select Aria List Item    Support_RequestStopPayment_StopPaymentOn    Check Range/Series
    Select Aria List Item    Support_RequestStopPaymentRange_MultiAccount    ${account_namenumber}
    Enter Aria Text    Support_RequestStopPaymentRange_StartingCheck    500
    Enter Aria Text    Support_RequestStopPaymentRange_EndingCheck    506
    Select Aria List Item    Support_RequestStopPaymentRange_ReasonList    Unsatisfactory Service

    Click On    Support_RequestStopPayment_NextButton
    Capture Page Screenshot

    Assert Page Contains    Request Stop Payment
    Assert Page Contains    ​Please review information for accuracy, then click Submit.

    Expect Text Contains    Support_RequestStopPaymentRange_Confirmation_MultiAccount    ${account_namenumber}
    Expect Text Contains    Support_RequestStopPaymentRange_Confirmation_CheckRange    500 to 506
    Expect Text Contains    Support_RequestStopPaymentRange_Confirmation_ReasonList    Unsatisfactory Service

    Click On    Support_RequestStopPaymentRange_EditButton
    Capture Page Screenshot

    ${Starting_CheckNo} =     Get Random Number
    ${Ending_CheckNo}=     Evaluate    ${${Starting_CheckNo}} + ${1}
    Log    ${Starting_CheckNo}
    Log    ${Ending_CheckNo}

    Enter Aria Text    Support_RequestStopPaymentRange_StartingCheck    ${Starting_CheckNo}
    Enter Aria Text    Support_RequestStopPaymentRange_EndingCheck    ${Ending_CheckNo}

    Click On    Support_RequestStopPayment_NextButton
    Capture Page Screenshot

    Assert Page Contains    Request Stop Payment
    Assert Page Contains    ​Please review information for accuracy, then click Submit.

    Expect Text Contains    Support_RequestStopPaymentRange_Confirmation_MultiAccount    ${account_namenumber}
    Expect Text Contains    Support_RequestStopPaymentRange_Confirmation_CheckRange    ${Starting_CheckNo} to ${Ending_CheckNo}
    Expect Text Contains    Support_RequestStopPaymentRange_Confirmation_ReasonList    Unsatisfactory Service

    Click On    Support_RequestStopPaymentRange_SubmitButton
    Sleep    3
    Capture Page Screenshot

    Click On    Support_RequestStopPaymentRange_CloseButton
    Click On    LeftNav_Support_RequestStopPayment
    Assert Page Contains    Request Stop Payment

    ${List} =     check exists    Support_RequestStopPaymentRange_SelectAccount
    Log    ${List}
    #Run Keyword If    ${List} == ${True}    Select Aria List Item    Support_RequestStopPaymentRange_SelectAccount    ${account_namenumber}
    Run Keyword If    ${List} == ${True}    select kendo dropdown    Support_RequestStopPaymentRange_SelectAccount_id    ${account_namenumber}
    #select kendo dropdown    Support_RequestStopPaymentRange_SelectAccount11    ${account_namenumber}
    #Select Aria List Item    Support_RequestStopPaymentRange_SelectAccount    ${account_namenumber}
    Sleep    3
    Capture Page Screenshot

    ${row_count} =    Get Table Row Count    RequestStopPayment_TransactionsTable
    log    ${row_count}
    ${row} =     Evaluate    ${row_count} - 1
    log    ${row}

    Open TSSO
    Go To Account Screen    ${account_number}    imi1
    print host object value    imi1_StopPay

    Go To Account Screen    ${account_number}    imi5
    Verify request Stop Payment Against Host

    save batch    imi1_StopPay    account_namenumber    row    row_count    Starting_CheckNo    Ending_CheckNo
    log    ${account_namenumber}

    [Teardown]    Log Out myBranch

Transaction Inquiry - Checking
    [Documentation]    UFT test: "Support - Account Inquiries - Transaction Inquiry - Submit Transaction Inquiry - Checking"
    [Tags]    qa_suite    support
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Load Browser
    Log In myBranch    ${username}    ${password}
    Click On    Ribbon_Support
    Click On    LeftNav_Support_TransactionInquiry
    Assert Page Contains    ​Submit Transaction Inquiry

    Select Aria List Item    TransactionInquiry_Reason    ${transaction_inquiryreason}
    Select Aria List Item    TransactionInquiry_Accounts    ${account_namenumber}
    Enter Aria Text    TransactionInquiry_Date    6/11/2014
    Enter Aria Text    TransactionInquiry_Amount    1.00
    Enter Aria Text    TransactionInquiry_Description    test
    Enter Aria Text    TransactionInquiry_Comments    online transaction
    Click On    Submit
    Sleep    3
    Assert Page Contains    Review Transaction Inquiry

    Expect Text Contains    TransactionInquiry_Review_Reason    ${transaction_inquiryreason}
    Expect Text Contains    TransactionInquiry_Review_Accounts    ${account_namenumber}
    Expect Text Contains    TransactionInquiry_Review_Date    6/11/2014
    Expect Text Contains    TransactionInquiry_Review_Amount    $1.00
    Expect Text Contains    TransactionInquiry_Review_Description    test
    Expect Text Contains    TransactionInquiry_Review_Comments    online transaction

    Click On    TransactionInquiry_Submit
    Sleep    3
    Assert Page Contains    Transaction Inquiry Complete
    Expect Text Contains    TransactionInquiry_Complete    Your Transaction Inquiry has been submitted.
    Capture Page Screenshot

    [Teardown]    Log Out myBranch

Transaction Inquiry - Loan
    [Documentation]    UFT test: "Support - Account Inquiries - Transaction Inquiry - Submit Transaction Inquiry - Loan"
    [Tags]    qa_suite    support
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Load Browser
    Log In myBranch    ${username}    ${password}
    Click On    Ribbon_Support
    Click On    LeftNav_Support_TransactionInquiry
    Assert Page Contains    ​Submit Transaction Inquiry

    Select Aria List Item    TransactionInquiry_Reason    ${transaction_inquiryreason}
    Select Aria List Item    TransactionInquiry_Accounts    ${account_namenumber}
    Enter Aria Text    TransactionInquiry_Date    6/11/2014
    Enter Aria Text    TransactionInquiry_Amount    1.00
    Enter Aria Text    TransactionInquiry_Description    test
    Enter Aria Text    TransactionInquiry_Comments    test
    Click On    Submit
    Sleep    3
    Assert Page Contains    Review Transaction Inquiry

    Expect Text Contains    TransactionInquiry_Review_Reason    ${transaction_inquiryreason}
    Expect Text Contains    TransactionInquiry_Review_Accounts    ${account_namenumber}
    Expect Text Contains    TransactionInquiry_Review_Date    6/11/2014
    Expect Text Contains    TransactionInquiry_Review_Amount    $1.00
    Expect Text Contains    TransactionInquiry_Review_Description    test
    Expect Text Contains    TransactionInquiry_Review_Comments    test

    Click On    TransactionInquiry_Submit
    Sleep    3
    Assert Page Contains    Transaction Inquiry Complete
    Expect Text Contains    TransactionInquiry_Complete    Your Transaction Inquiry has been submitted.
    Capture Page Screenshot

    [Teardown]    Log Out myBranch

My messages - Secure Messages
    [Documentation]    UFT test: "Support - Support - My Messages - Secure Messages"
    [Tags]    qa_suite    support
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Load Browser
    Log In myBranch    ${username}    ${password}
    Click On    Ribbon_Support
    Click On    LeftNav_Support_MyMessages
    Assert Page Contains    Secure Messages

    Click On    Support_MyMessages_ComposeButton

    Select Aria List Item    Support_MyMessages_Subject    ${subject}
    Select Aria List Item    Support_MyMessages_Account    ${account_namenumber}
    Enter Aria Text    Support_MyMessages_Message    test

    Click On    Support_MyMessages_SendButton
    Sleep    1
    Expect Text Contains    Confirmation_Message    Your Message has been successfully sent.

    Click On    Support_MyMessages_CloseButton
    Sleep    3
    Capture Page Screenshot

    [Teardown]    Log Out myBranch

RequestCheckCopy
    [Documentation]    UFT test: "Support - Account Inquiries - Request Check Copy"
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Load Browser
    Log In myBranch    ${username}    ${password}
    Click On    Ribbon_Support
    Click On    LeftNav_Support_RequestCheckCopy
    Assert Page Contains    Request Check Copy

    Select Aria List Item    Support_RequestCheckCopy_Account    ${account_namenumber}
    Enter Aria Text    Support_RequestCheckCopy_CheckNumber    1234
    Enter Aria Text    Support_RequestCheckCopy_Amount    1.00
    Enter Text    Support_RequestCheckCopy_DateCleared    12/31/2010
    Enter Text    Support_RequestCheckCopy_Comments    test
    Capture Page Screenshot

    Click On    Support_RequestCheckCopy_NextButton
    Capture Page Screenshot

    Expect Text Contains    VerifyCheckCopyRequest_Account    ${account_namenumber}
    Expect Text Contains    VerifyCheckCopyRequest_CheckNo    1234
    Expect Text Contains    VerifyCheckCopyRequest_Amount    $1.00
    Expect Text Contains    VerifyCheckCopyRequest_DateCleared    12/31/2010
    Expect Text Contains    VerifyCheckCopyRequest_DeliveryMethod    test

    Click On    Support_RequestCheckCopy_SubmitButton
    Capture Page Screenshot

    Assert Page Contains    Check Copy Request Complete
    Assert Page Contains    Your Check Copy Request has been submitted
    Capture Page Screenshot

    [Teardown]    Log Out myBranch

ReOrderChecks
    [Documentation]    UFT test: "Support - Account Inquiries - Re-Order Checks"
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Load Browser
    Log In myBranch    ${username}    ${password}
    Click On    Ribbon_Support
    Click On    LeftNav_Support_ReOrderChecks
    Assert Page Contains    Re-Order Checks

    Select Aria List Item Containing    Support_ReOrderChecks_SelectAccount    ${account_namenumber}
    #Select Aria List Item    Support_ReOrderChecks_SelectAccount    ${account_namenumber}
    Capture Page Screenshot

    Click On    Support_ReOrderChecks_SubmitButton

    Register Window
    Log Title
    Title Should Be    OrderMyChecks.com® Official Site - Order Checks by Harland Clarke
    Capture Page Screenshot
    Close Window
    Unregister Window

    [Teardown]    Log Out myBranch





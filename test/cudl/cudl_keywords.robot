*** Variables ***

${QAT}       https://ss-appq.cudl.com/logonform.aspx
${UAT}     notused


*** Keywords ***
Open CUDL
    [Arguments]    ${BROWSER}    ${REGION}
    ${URL}    Set Variable If
    ...    "${REGION}" == "QAT"    ${QAT}
    ...    "${REGION}" == "UAT"    ${UAT}
    Set Global Variable    ${URL}
    Set Global Variable    ${BROWSER}
    Open Browser    ${URL}    ${BROWSER}
    Log    ${browser}
    Register Window

Log In CUDL
    [Arguments]    ${username}    ${password}
    Maximize Browser Window
    Enter Text    Login_ID    ${username}
    Enter Text    Login_Password    ${password}
    Click On    Login OK
    Click On    Continue_WelcomePage



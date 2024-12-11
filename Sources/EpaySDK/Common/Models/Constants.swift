//
//  Constants.swift
//  EpaySDK
//
//  Created by a1pamys on 4/1/20.
//  Copyright © 2020 Алпамыс. All rights reserved.
//

import Foundation

public enum EnvironmentType {
    case prod
    case preProd
    case dev
}

struct Constants {
    
    static let statusBar = "statusBarWindow.statusBar"
    static var publicKey = "MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAvZSmF6cGaZmjeWqnquUsclylxU3JuZ5zUAeQSfcAMlX37CsoSs7QWUOwVSrurLGtVB4IEHH9wmJTgVTt3I5Amm6AQ/vzeq+vB1mjNXy1V6kgjAlfJncJBq9nUKOmIihrV6K5ehIXoFXVlovQAmUm3YJ7zXwuPOqCqu/wm7POhtGI8KZ8Sdkm2uqq/jtwG7+BGu0CSrZWeWyAparVieCeizjDN3KXizXaYw9Y1hNUqU4drh/kphVxxgSb296/TVgOoYIqi2cTNRAOVDtEqZ05wH7L3u6jKjwTtQLdFRjzm5J2r+HPylAxePkU1LONFNEHtEBxEUdPOBCZrWNbz3N7DUSCwKl+H+nXYUetWYhdXH6Vqnojm8Nq8e/txPnXAJiTzndV0FHzEwVmSwzgKSu54qXrXq13f4PcvVvFUtTv8NWk2nlAHV1W9R07PvZlFN5wPJfZpFv47te+kx9qlQuaJbbz0W/YXSXZEHAMY7/ZQYD/1qG8uz7LQxut33q1iW1p3kSO3UyVCRwONmH1sjTXvDx5mb3es61h8cI4xjfpCiHWtPSZLfF8Ce+J4x+2AvcYH7C4x3VqroMpSo7zpWX0uXRX4BGaB2B5IM83yuGt7Zkg5R5x2dKE1E1wAErewyvhSqQne0QC16w00rNgDGhGKz/+DyszrX2VGmTockF/7FcCAwEAAQ=="

    struct Notification {
        static let main = "sdk_response"
    }
    
    struct Url {
        static var auth = "https://epay-oauth.homebank.kz"  
        static var base = "https://epay-api.homebank.kz"
        static var homeBankDeepLink = "kz.homebank.mobile"
        static var environment: EnvironmentType! {
            didSet {
                switch environment {
                case .prod:
                    publicKey = "MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAvZSmF6cGaZmjeWqnquUsclylxU3JuZ5zUAeQSfcAMlX37CsoSs7QWUOwVSrurLGtVB4IEHH9wmJTgVTt3I5Amm6AQ/vzeq+vB1mjNXy1V6kgjAlfJncJBq9nUKOmIihrV6K5ehIXoFXVlovQAmUm3YJ7zXwuPOqCqu/wm7POhtGI8KZ8Sdkm2uqq/jtwG7+BGu0CSrZWeWyAparVieCeizjDN3KXizXaYw9Y1hNUqU4drh/kphVxxgSb296/TVgOoYIqi2cTNRAOVDtEqZ05wH7L3u6jKjwTtQLdFRjzm5J2r+HPylAxePkU1LONFNEHtEBxEUdPOBCZrWNbz3N7DUSCwKl+H+nXYUetWYhdXH6Vqnojm8Nq8e/txPnXAJiTzndV0FHzEwVmSwzgKSu54qXrXq13f4PcvVvFUtTv8NWk2nlAHV1W9R07PvZlFN5wPJfZpFv47te+kx9qlQuaJbbz0W/YXSXZEHAMY7/ZQYD/1qG8uz7LQxut33q1iW1p3kSO3UyVCRwONmH1sjTXvDx5mb3es61h8cI4xjfpCiHWtPSZLfF8Ce+J4x+2AvcYH7C4x3VqroMpSo7zpWX0uXRX4BGaB2B5IM83yuGt7Zkg5R5x2dKE1E1wAErewyvhSqQne0QC16w00rNgDGhGKz/+DyszrX2VGmTockF/7FcCAwEAAQ=="
                    auth = "https://epay-oauth.homebank.kz"
                    base = "https://epay-api.homebank.kz"
                    homeBankDeepLink = "kz.homebank.mobile"
                case .preProd:
                    publicKey = "MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAvZSmF6cGaZmjeWqnquUsclylxU3JuZ5zUAeQSfcAMlX37CsoSs7QWUOwVSrurLGtVB4IEHH9wmJTgVTt3I5Amm6AQ/vzeq+vB1mjNXy1V6kgjAlfJncJBq9nUKOmIihrV6K5ehIXoFXVlovQAmUm3YJ7zXwuPOqCqu/wm7POhtGI8KZ8Sdkm2uqq/jtwG7+BGu0CSrZWeWyAparVieCeizjDN3KXizXaYw9Y1hNUqU4drh/kphVxxgSb296/TVgOoYIqi2cTNRAOVDtEqZ05wH7L3u6jKjwTtQLdFRjzm5J2r+HPylAxePkU1LONFNEHtEBxEUdPOBCZrWNbz3N7DUSCwKl+H+nXYUetWYhdXH6Vqnojm8Nq8e/txPnXAJiTzndV0FHzEwVmSwzgKSu54qXrXq13f4PcvVvFUtTv8NWk2nlAHV1W9R07PvZlFN5wPJfZpFv47te+kx9qlQuaJbbz0W/YXSXZEHAMY7/ZQYD/1qG8uz7LQxut33q1iW1p3kSO3UyVCRwONmH1sjTXvDx5mb3es61h8cI4xjfpCiHWtPSZLfF8Ce+J4x+2AvcYH7C4x3VqroMpSo7zpWX0uXRX4BGaB2B5IM83yuGt7Zkg5R5x2dKE1E1wAErewyvhSqQne0QC16w00rNgDGhGKz/+DyszrX2VGmTockF/7FcCAwEAAQ=="
                    auth = "https://preprod-epay-oauth.epayment.kz"
                    base = "https://preprod-epay-api.epayment.kz"
                    homeBankDeepLink = "kz.homebank.mobile"
                default:
                    publicKey = "MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAqoATnGMtByQojuoYFKExvEqszShV2vk6chCJFx0/vmSHBqcCTazhJqBmYU9gyM/TjVWLsjFAbd4nvCxIGpqFg3J7UJccfODKibyfSUSqGsAJE1MJh3EaJivkd85/FkZkv3zBeT/193NmakNs0+T+PUMmSdAPSnfUWi2KSIp48mSA38CbMvOwndkKNEeqCoIQn/fApfZ8MWIEFVd3gpfsVe0zYhSjvTOHPD0/7TOdcQyArxLZY0yS7m32rUOibuO7EhGNQL/bC73ZbuS5nXhra03nNIW3FfSJUTJBjVWDZRoNk9gm4pOimAeb0IiqnmlTPOvkqHYsOEjQ8KJAFlGO1igelk1+dA5ZiY6r0YExc1KnW7UsnGk6nr7cgOR2po/sa4kctiKLqlGA35ILmUBQYb6iReCQkggXMOvmP6p+4wEt1B7V8UJxzFZcQZ5QSRIk3o3pVrfY0gksidl0Xt5mft+E6a77ZQKG4TOQS9Ly1mIJ2qqaWqCWglVMWFiFCx9dXTN0RMli1T0rs1gA2jsPz2/HiyY8EUp6t4Ufc8VbJYG9vt24UTwYgu+qDEBjggm5YKVCxjCvhJWwh9LaL9UuK46Apgr5wgEyMIJZRO7RxkjKkJI29FAP3wEs9y+/3qsjH3chFzdX0/+6lA+9lePKPX0Z5SPexWRiQp9bND4iZRcCAwEAAQ=="
                    auth = "https://testoauth.homebank.kz/epay2"
                    base = "https://testepay.homebank.kz/api"
                    homeBankDeepLink = "kz.homebank.mobile.dev"
                }
            }
        }
    }
    
    struct DeepLink {
        static var homeBank = "homebank://"
    }
    
    struct Images {
        static let logo = "logo"
        static let hbLogo = "hb-logo"
        static let time = "time"
        static let creditCard = "credit-card"
        static let applePayWhite = "apple-pay-w"
        static let applePayBlack = "apple-pay-b"
        static let applePayDefault = "apple-pay"
        static let cvv = "zcvv"
        static let success = "success"
        static let fail = "fail"
        static let scan = "scan"
        static let wait = "wait"
        static let qr = "qr"
        static let halykID = "halykID"
        static let arrowDown = "arrowDown"
        static let visa = "visa"
        static let mastercard = "mastercard"
        static let wallet = "wallet"
        static let arrowDownSharp = "arrowDownSharp"
        static let mcTranslucent = "mcTranslucent"
        static let visaTranslucent = "visaTranslucent"
        static let personCircle = "personCircle"
        static let payCredit = "pay_credit"
        static let installment = "installment"
        static let chevronDownCircleOutline = "chevronDownCircleOutline"
    }
    
    struct Localizable {
        static let tableName = "Localizable"
        static let introText = "intro_text"
        static let iosSdkPayment = "iOS_SDK_payment"
        static let choosePaymentMethod = "choose_payment_method"
        static let invoiceId = "invoice_id"
        static let halykLicense = "halyk_license_fmt"
        static let halyJsc = "halyk_jsc"
        static let cancel = "cancel"
        static let payAmount = "pay_amount_fmt"
        static let payInstallment = "pay_installment"
        static let payCredit = "pay_credit"
        static let confirmSubscribe = "confirm_subscribe"
        static let fillInCardDetails = "fill_in_card_details"
        static let emailRequiredHint = "email_required_hint"
        static let phoneHint = "phone_hint"
        static let cardNumberHint = "card_number_hint"
        static let cardMonthHint = "card_month_hint"
        static let cardYearHint = "card_year_hint"
        static let cardCvvHint = "card_cvv_hint"
        static let cardClientNameHint = "card_client_name_hint"
        static let cardCvvHintTitle = "card_cvv_hint_title"
        static let cardCvvHintMessage = "card_cvv_hint_message"
        static let loadingText = "loading_text"
        static let back = "back"
        static let errorPaymentDefault = "error_payment_default"
        static let errorTitleToken = "error_title_token"
        static let errorDescriptionToken = "error_description_token"
        static let paymentAccepted = "payment_accepted"
        static let paymentDeclined = "payment_declined"
        static let reference = "reference"
        static let close = "close"
        static let commissionLabel = "commission_label"
        static let merchantLabel = "merchant_label"
        static let tryAgain = "try_again"
        static let backToEpayForm = "back_to_epay_form"
        static let soon = "soon"
        static let applePayLabel = "applePayLabel"
        static let mainCancel = "main_cancel"
        static let cameraUsageTitle = "camera_title"
        static let cameraUsageMessage = "camera_message"
        static let onlineShopPayment = "online_shop_payment"
        static let confirmSubscription = "confirm_subscription"
        static let autoPaymentSuccess = "auto_payment_success"
        static let autoPaymentAmount = "auto_payment_amount"
        static let periodLabel = "period_label"
        static let subscriptionDateLabel = "subscription_date_label"
        static let subscriptionEndDateLabel = "subscription_end_date_label"
        static let autoPaymentDeclined = "auto_payment_declined"
        static let weekly = "Weekly"
        static let monthly = "Monthly"
        static let quarterly = "Quarterly"
        static let weeklyAutopaymentQuestion = "weekly_autopayment_question"
        static let monthlyAutopaymentQuestion = "monthly_autopayment_question"
        static let quarterlyAutopaymentQuestion = "quarterly_autopayment_question"
        static let useBonuses = "use_bonuses"
        static let willBeCharged = "will_be_charged"
        static let fromBonus = "bonus_bubble_label_text"
        static let fromCard = "card_bubble_label_text"
        static let myApplicationsQRDescription = "my_applications_qr_description"
        static let paymentInOnlineShop = "payment_in_online_shop"
        static let step1Of3 = "step_1_of_3"
        static let step2Of3 = "step_2_of_3"
        static let step1Description = "step_1_description"
        static let step2Description = "step_2_description"
        static let pleaseWait = "please_wait"
        static let doNotUpdatePage = "do_not_update_page"
        static let decisionInProgress = "decision_in_progress"
        static let checkingData = "checking_data"
        static let applicationIsRejected = "application_is_rejected"
        static let tryToChangeWatOfPayment = "try_to_change_way_of_payment"
        static let installmentIsAccepted = "installment_is_accepted"
        static let installmentRegistrationIsEnded = "installment_registration_is_ended"
        static let scanViaQr = "scan_via_qr"
        static let creditForMonths = "credit_for_months"
        static let installmentForMonths = "installment_for_months"
        static let monthlyPayment = "monthly_payment"
        static let overpaymentByCredit = "overpayment_by_credit"
        static let commission = "commission"
        static let seller = "seller"
        static let order = "order"
        static let homeshop = "homeshop"
        static let installment = "installment"
        static let scanQRToPay = "scan_qr_to_pay"
        static let transferDeclined = "transfer_declined"
        static let saveCard = "save_card"
    }
    
    struct ColorScheme {
        static let bg = "{\"color1\":\"#FFFFFF\",\"color2\":\"#FFFFFF\",\"gradient\":\"#FFFFFF\"}"
        static let cardBg = "{\"color1\":\"#05B9A6\",\"color2\":\"#05B9A6\",\"gradient\":\"#05B9A6\"}"
        static let buttons = "#00a8ff"
        static let text = "#807f7f"
        static let cardText = "#FFFFFF"
    }
}

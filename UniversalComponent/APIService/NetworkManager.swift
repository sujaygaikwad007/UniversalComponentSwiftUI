import Foundation

class NetworkManager {
    
    private let networkService = NetworkService()
    
    // Generic GET request
    func performGETRequest<T: Codable>(urlString: String, responseType: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        networkService.request(urlString: urlString, method: .get) { (result: Result<T, Error>) in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
    // Generic POST request
    func performPostRequest<T: Codable>(urlString: String, method: HTTPMethod, requestBody: Data? = nil, responseType: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        networkService.request(urlString: urlString, method: method, requestBody: requestBody) { (result: Result<T, Error>) in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
    // Generic PATCH request
    func performPatchRequest<T: Codable>(urlString: String, requestBody: Data? = nil, responseType: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        networkService.request(urlString: urlString, method: .patch, requestBody: requestBody) { (result: Result<T, Error>) in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
    
}


///Below code show you how to call API

//class OnboardingViewModel: ObservableObject {
//    @Published var userResponse: RegisterUserResponse?
//    @Published var dropDownValues: DropDownValues?
//    @Published var emailSignUp : EmailVerifyResponse?
//    @Published var verifyOtpResponse : VerifyOtpResponse?
//    @Published var resendOtpResponse : ResendOtpResponse?
//    @Published var nameLastNameResponse : NameLastNameResponse?
//
//    @Published var errorMessage: String?
//
//    private let networkManager = NetworkManager()
//
//    // to login with Google and Apple
//    func loginWithGoogleAndApple(email: String, firstName: String, lastName: String) {
//        let userRequest = RegisterUserRequest(email: email, firstName: firstName, lastName: lastName)
//
//        do {
//            let requestBody = try JSONEncoder().encode(userRequest)
//            networkManager.performPostRequest(urlString: APIEndpoint.googleLogin, method: .post, requestBody: requestBody, responseType: RegisterUserResponse.self) { [weak self] result in
//                switch result {
//                case .success(let response):
//                    self?.userResponse = response
//                    print("User logged in successfully: \(response.message)")
//                    print("Token: \(response.data?.token ?? "")")
//                case .failure(let error):
//                    self?.errorMessage = error.localizedDescription
//                    print("Error: \(error.localizedDescription)")
//                }
//            }
//        } catch {
//            print("Failed to encode request loginWithGoogleAndApple: \(error.localizedDescription)")
//        }
//    }
//
//
//    //Signup method
//    func signUpUser(email: String, password: String, completion: @escaping (Bool) -> Void) {
//
//        let signUpRequest = signUpRequest(email: email, password: password)
//
//        do {
//            let requestBody = try JSONEncoder().encode(signUpRequest)
//            networkManager.performPostRequest(urlString: APIEndpoint.signUp, method: .post, requestBody: requestBody, responseType: EmailVerifyResponse.self) { [weak self] result in
//                switch result {
//                case .success(let response):
//                    self?.emailSignUp = response
//                    print("SignUp message----\(response.message ?? "")")
//                    print("SignUp Status----\(response.status ?? false)")
//                    completion(response.status ?? false)
//                case .failure(let error):
//                    self?.errorMessage = error.localizedDescription
//                    print("Error: \(error.localizedDescription)")
//                    completion(false)
//                }
//            }
//        } catch {
//            print("Failed to encode request signUpUser: \(error.localizedDescription)")
//            completion(false)
//        }
//    }
//
//    //Otp verify
//    func verifyOtp(email: String, otp: String, completion: @escaping (Bool) -> Void) {
//
//        let otpRequest  = OtpRequest(email: email, otp: otp)
//
//        do {
//            let requestBody = try JSONEncoder().encode(otpRequest)
//            networkManager.performPostRequest(urlString: APIEndpoint.emailVerification, method: .post, requestBody: requestBody, responseType: VerifyOtpResponse.self) { [weak self] result in
//                switch result {
//                case .success(let response):
//                    self?.verifyOtpResponse = response
//                    print("verifyOtp message----\(response.message ?? "")")
//                    print("verifyOtp Status----\(response.status ?? false)")
//                    completion(response.status ?? false)
//                case .failure(let error):
//                    self?.errorMessage = error.localizedDescription
//                    print("Error: \(error.localizedDescription)")
//                    completion(false)
//                }
//            }
//        } catch {
//            print("Failed to encode request verifyOtp: \(error.localizedDescription)")
//            completion(false)
//        }
//    }
//
//
//    //Resend Otp
//    func resendOtp(email: String) {
//        let resendOtpRequest = ResendOtpRequest(email: email)
//
//        do {
//            let requestBody = try JSONEncoder().encode(resendOtpRequest)
//            networkManager.performPostRequest(urlString: APIEndpoint.resendOTP, method: .post, requestBody: requestBody, responseType: ResendOtpResponse.self) { [weak self] result in
//                switch result {
//                case .success(let response):
//                    self?.resendOtpResponse = response
//                    print("Resend otp Staus---- \(response.status ?? false)")
//                    print("Resend otp message---- \(response.message ?? "")")
//
//                case .failure(let error):
//                    self?.errorMessage = error.localizedDescription
//                    print("Error: \(error.localizedDescription)")
//                }
//            }
//        } catch {
//            print("Failed to encode request resendOtp: \(error.localizedDescription)")
//        }
//    }
//
//
//    //Name and last Name
//    func firstNameLastName(firstName: String, lastName: String, completion: @escaping (Bool) -> Void) {
//
//        let firstNameLastNameRequest = NameLastNameRequest(firstName: firstName, lastName: lastName)
//
//        do {
//            let requestBody = try JSONEncoder().encode(firstNameLastNameRequest)
//            networkManager.performPatchRequest(urlString: APIEndpoint.registerUser, requestBody: requestBody, responseType: NameLastNameResponse.self) { [weak self] result in
//                switch result {
//                case .success(let response):
//                    self?.nameLastNameResponse = response
//                    print("firstNameLastName message----\(response.message ?? "")")
//                    print("firstNameLastName Status----\(response.status ?? false)")
//                    completion(response.status ?? false)
//                case .failure(let error):
//                    self?.errorMessage = error.localizedDescription
//                    print("Error: \(error.localizedDescription)")
//                    completion(false)
//                }
//            }
//        } catch {
//            print("Failed to encode request firstNameLastName: \(error.localizedDescription)")
//            completion(false)
//        }
//    }
//
//
//
//
//    // Fetch dropdown values
//    func fetchDropDownValues() {
//        networkManager.performGETRequest(urlString: APIEndpoint.dropdownValues, responseType: DropDownValues.self) { [weak self] result in
//            switch result {
//            case .success(let response):
//                self?.dropDownValues = response
//                print("Dropdown values received successfully:")
//                print("Status: \(response.status ?? false)")
//                print("Message: \(response.message ?? "")")
//            case .failure(let error):
//                self?.errorMessage = error.localizedDescription
//                print("Error: \(error.localizedDescription)")
//            }
//        }
//    }
//
//
//}


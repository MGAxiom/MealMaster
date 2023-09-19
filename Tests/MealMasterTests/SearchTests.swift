//
//  MealMasterTests.swift
//  MealMasterTests
//
//  Created by Maxime Girard on 06/07/2023.
//

import XCTest
@testable import MealMaster
import Alamofire

final class MealMasterTests: XCTestCase {

    override func setUp() {
        super.setUp()
        UserSettings.currentSettings.add(diet: Diet.vegan)
    }
    
    override func tearDown() {
        super.tearDown()
        UserSettings.currentSettings.add(diet: Diet.omnivore)
    }

    //MARK: RecipeAPI tests
    
    func testGetRecipeShouldPostSuccessCallBackIfNoErrorAndCorrectData() {
        let fakeResponse = FakeResponse(response: FakeResponseData.responseOK, data: FakeResponseData.correctData, error: nil)
        let recipeSessionFake = RecipeSessionFake(fakeResponse: fakeResponse)
        let recipeSearchService = RecipeSearch(session: recipeSessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        recipeSearchService.recipeAPI(userInput: "tomato") { (result) in
            switch result {
            case .success(let item):
                let label = item[0].title
                let time = item[0].time
                let calories = item[0].calories
                let ingredients = item[0].ingredients
                XCTAssertEqual(label, "Tomato Gravy")
                XCTAssertEqual(time, "10min")
                XCTAssertEqual(calories, "1018")
                XCTAssertEqual([ingredients], ["1/4 cup bacon drippings, 1/4 cup all-purpose flour, 1 tablespoon tomato paste, 1 (15-ounce) can diced tomatoes, with juice, 1 cup milk, 1/4 cup heavy cream, Kosher salt and freshly ground black pepper"])
            default:
                XCTFail()
                break
            }

            //XCTAssertNil(recipesSearchService)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5000)
//        wait(for: [expectation], timeout: 0.01)
    }

    func testGetRecipe_WhenInvalidDataIsPassed_ThenShouldReturnFailedCallback() {
        let fakeResponse = FakeResponse(response: FakeResponseData.responseOK, data: FakeResponseData.incorrectData, error: nil)
        let recipeSessionFake = RecipeSessionFake(fakeResponse: fakeResponse)
        let recipeSearchService = RecipeSearch(session: recipeSessionFake)

        let expectation = XCTestExpectation(description: "Wait for queue change.")
        recipeSearchService.recipeAPI(userInput: "tomato") { (result) in
            switch result {
            case .failure(let error):
                XCTAssertTrue(error is HTTPError)
                XCTAssertTrue(error as? HTTPError == .invalidJson)
            default:
                XCTFail()
                break
            }

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetRecipe_WhenIncorrectResponse_ThenShouldReturnFailedCallback() {
        let fakeResponse = FakeResponse(response: FakeResponseData.responseKO, data: FakeResponseData.correctRecipeData, error: nil)
        let recipeSessionFake = RecipeSessionFake(fakeResponse: fakeResponse)
        let recipeSearchService = RecipeSearch(session: recipeSessionFake)

        let expectation = XCTestExpectation(description: "Wait for queue change.")
        recipeSearchService.recipeAPI(userInput: "tomato") { (result) in
            switch result {
            case .failure(let error):
                XCTAssertTrue(error is AFError)
                switch (error as? AFError) {
                case .responseValidationFailed(reason: .unacceptableStatusCode(code: 500)):
                    break
                default:
                    XCTFail("Should be .unacceptableStatusCode(code: 500)")
                }
            default:
                XCTFail()
                break
            }

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }

    //MARK: Random Recipe tests
    func testGetRandomRecipeShouldPostSuccessCallBackIfNoErrorAndCorrectData() {
        let fakeResponse = FakeResponse(response: FakeResponseData.responseOK, data: FakeResponseData.correctRecipeData, error: nil)
        let recipeSessionFake = RecipeSessionFake(fakeResponse: fakeResponse)
        let recipeSearchService = RecipeSearch(session: recipeSessionFake)

        let expectation = XCTestExpectation(description: "Wait for queue change.")
        recipeSearchService.randomRecipeAPI { result in
            switch result {
            case .success(let item):
                let label = item[0].title
                let time = item[0].time
                let calories = item[0].calories
                let ingredients = item[0].ingredients
                XCTAssertEqual(label, "Tomato Gravy")
                XCTAssertEqual(time, "10min")
                XCTAssertEqual(calories, "1018")
                XCTAssertEqual([ingredients], ["1/4 cup bacon drippings, 1/4 cup all-purpose flour, 1 tablespoon tomato paste, 1 (15-ounce) can diced tomatoes, with juice, 1 cup milk, 1/4 cup heavy cream, Kosher salt and freshly ground black pepper"])
            default:
                XCTFail()
                break
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5000)
        //        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetRandomRecipe_WhenInvalidDataIsPassed_ThenShouldReturnFailedCallback() {
        let fakeResponse = FakeResponse(response: FakeResponseData.responseOK, data: FakeResponseData.incorrectData, error: nil)
        let recipeSessionFake = RecipeSessionFake(fakeResponse: fakeResponse)
        let recipeSearchService = RecipeSearch(session: recipeSessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        recipeSearchService.randomRecipeAPI{ (result) in
            switch result {
            case .failure(let error):
                XCTAssertTrue(error is HTTPError)
                XCTAssertTrue(error as? HTTPError == .invalidJson)
            default:
                XCTFail()
                break
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetRandomRecipe_WhenIncorrectResponse_ThenShouldReturnFailedCallback() {
        let fakeResponse = FakeResponse(response: FakeResponseData.responseKO, data: FakeResponseData.correctRecipeData, error: nil)
        let recipeSessionFake = RecipeSessionFake(fakeResponse: fakeResponse)
        let recipeSearchService = RecipeSearch(session: recipeSessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        recipeSearchService.randomRecipeAPI { (result) in
            switch result {
            case .failure(let error):
                XCTAssertTrue(error is AFError)
                switch (error as? AFError) {
                case .responseValidationFailed(reason: .unacceptableStatusCode(code: 500)):
                    break
                default:
                    XCTFail("Should be .unacceptableStatusCode(code: 500)")
                }
            default:
                XCTFail()
                break
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    //MARK: - FoodAPI tests
    
    func testGetFoodShouldPostSuccessCallBackIfNoErrorAndCorrectData() {
        let fakeResponse = FakeResponse(response: FakeResponseData.responseOK, data: FakeResponseData.correctFoodData, error: nil)
        let recipeSessionFake = RecipeSessionFake(fakeResponse: fakeResponse)
        let foodSearchService = FoodSearch(session: recipeSessionFake)
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        foodSearchService.foodAPI(userInput: "Butter") { (result) in
            switch result {
            case .success(let item):
                let brand = item[0].brand
                let category = item[0].category
                let image = item[0].image
                let label = item[0].label
                XCTAssertEqual(label, "Butter")
                XCTAssertEqual(brand, nil)
                XCTAssertEqual(image, "https://www.edamam.com/food-img/713/71397239b670d88c04faa8d05035cab4.jpg")
                XCTAssertEqual(category, "Generic foods")
            default:
                XCTFail()
                break
            }
            
            //XCTAssertNil(recipesSearchService)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetFood_WhenInvalidDataIsPassed_ThenShouldReturnFailedCallback() {
        let fakeResponse = FakeResponse(response: FakeResponseData.responseOK, data: FakeResponseData.incorrectData, error: nil)
        let recipeSessionFake = RecipeSessionFake(fakeResponse: fakeResponse)
        let foodSearchService = FoodSearch(session: recipeSessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        foodSearchService.foodAPI(userInput: "Butter") { (result) in
            switch result {
            case .failure(let error):
                XCTAssertTrue(error is HTTPError)
                XCTAssertTrue(error as? HTTPError == .invalidJson)
            default:
                XCTFail()
                break
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetFood_WhenIncorrectResponse_ThenShouldReturnFailedCallback() {
        let fakeResponse = FakeResponse(response: FakeResponseData.responseKO, data: FakeResponseData.correctFoodData, error: nil)
        let recipeSessionFake = RecipeSessionFake(fakeResponse: fakeResponse)
        let foodSearchService = FoodSearch(session: recipeSessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        foodSearchService.foodAPI(userInput: "Butter") { (result) in
            switch result {
            case .failure(let error):
                XCTAssertTrue(error is AFError)
                switch (error as? AFError) {
                case .responseValidationFailed(reason: .unacceptableStatusCode(code: 500)):
                    break
                default:
                    XCTFail("Should be .unacceptableStatusCode(code: 500)")
                }
            default:
                XCTFail()
                break
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
}

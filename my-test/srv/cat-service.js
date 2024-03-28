// cat-service.js
const cds = require('@sap/cds');

module.exports = cds.service.impl(async (srv) => {


  // Handler for the addReview action
  srv.on('addReview', async (req) => {
    const { rating, title, text } = req.data;
    const test = req._params[0]?.TestID;

    // Fetch the test instance associated with the given ID
    const testInstance = await cds.run(
      SELECT.one('my.TestService.Tests')
        .where({ TestID: test })
    );

    if (!testInstance) {
      req.error(404, `Test with ID ${test} not found.`);
    }

    // Create the review
    const review = await cds.run(
      INSERT.into('my.TestService.Reviews')
        .entries({ test_TestID: test, rating: rating, title: title, text: text })
    );

    console.log(`Review added for test ${test}. Rating: ${rating}`);

    // Calculate the average rating for the test
    const reviews = await cds.run(
      SELECT.from('my.TestService.Reviews')
        .where({ test_TestID: test })
    );

    // Update the test with the new average rating
    let totalRating = 0;
    for (const review of reviews) {
      totalRating += review.rating;
    }
    const averageRating = totalRating / reviews.length;

    await cds.run(
      UPDATE('my.TestService.Tests')
        .set({ rating: averageRating })
        .where({ TestID: test })
    );

    console.log(`Average rating updated for test ${test}. New rating: ${averageRating}`);

    return { review, reviews }; // Return the newly added review and all reviews
  });




  // Handler for the assignQuestionsToTest action
  srv.on('assignQuestionsToTest', async (req) => {

    console.log("requset data ", req?._params)
    const { questionsCount } = req.data;
    const testId = req._params[0]?.TestID;
    console.log("Test ID:", testId);

    const unassociatedQuestions = await cds.run(
      SELECT.from('my.TestService.Questions').where({ test_TestID: null })
    );
    console.log("unassociatedQuestion ", unassociatedQuestions);


    // Check if there are enough questions to associate
    if (unassociatedQuestions.length >= 0 && unassociatedQuestions.length < questionsCount) {
      console.log(`Not enough unassociated questions available. Available: ${unassociatedQuestions.length}, Requested: ${questionsCount}`);
      req.error({
        code: '204',
        message: 'Not enough unassociated questions available',
        target: 'some_field',
        status: 418
      })
      return { success: false, message: `Not enough unassociated questions available.` };
    }

    // Shuffle the questions array to randomize selection
    const shuffledQuestions = shuffleArray(unassociatedQuestions);
    console.log("Shuffled questions:", shuffledQuestions);

    // Select the first 'questionsCount' questions
    const selectedQuestions = shuffledQuestions.slice(0, questionsCount);
    console.log("Selected questions:", selectedQuestions);

    // Associate selected questions with the test
    const questionIdsToUpdate = selectedQuestions.map(q => q.QuestionID);
    console.log("question selcted ", questionIdsToUpdate);

    for (const questionId of questionIdsToUpdate) {
      await cds.run(
        UPDATE('my.TestService.Questions')
          .set({ test_TestID: testId })
          .where({ QuestionID: questionId })
      );
    }

    console.log("Questions associated successfully.");
    await cds.run(
      UPDATE('my.TestService.Tests')
      .set({ associatedQuestion: true })
      .where({ TestID: testId }))

      
    const updatedQuestions = await cds.run(
      SELECT.from('my.TestService.Questions').where({ QuestionID: { in: questionIdsToUpdate } })
    );
    console.log("Updated Questions:", updatedQuestions);



    // Return a success message
    return updatedQuestions;
  });
});

// Function to shuffle an array
function shuffleArray(array) {
  for (let i = array.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [array[i], array[j]] = [array[j], array[i]];
  }
  return array;
}

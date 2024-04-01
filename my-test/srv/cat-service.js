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

  //suppliers
  srv.on("READ", 'Tests', async (req, next) => {
    if (!req.query.SELECT.columns) return next();
    const expandIndex = req.query.SELECT.columns.findIndex(
        ({ expand, ref }) => expand && ref[0] === "supplier"
    );
    console.log("this expand index ",expandIndex)
    if (expandIndex < 0) return next();

    // Remove expand from query
    req.query.SELECT.columns.splice(expandIndex, 1);

    // Make sure supplier_ID will be returned
    if (!req.query.SELECT.columns.indexOf('*') >= 0 &&
        !req.query.SELECT.columns.find(
            column => column.ref && column.ref.find((ref) => ref == "supplier_ID"))
    ) {
       console.log("supplier id if ");
        req.query.SELECT.columns.push({ ref: ["supplier_ID"] });
    }

    const test = await next();
    console.log("test from next ", test)

    const asArray = x => Array.isArray(x) ? x : [ x ];

    // Request all associated suppliers
    const supplierIds = asArray(test).map(test => test.supplier_ID);
    console.log("supplier id", supplierIds)
    const suppliers = await bupa.run(SELECT.from('TestService.Suppliers').where({ ID: supplierIds }));
    console.log("suppliers ", supplierIds)

    // Convert in a map for easier lookup
    const suppliersMap = {};
    for (const supplier of suppliers)
        suppliersMap[supplier.ID] = supplier;

    // Add suppliers to result
    for (const note of asArray(test)) {
        note.supplier = suppliersMap[note.supplier_ID];
    }

    return test;
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
  
  const bupa = await cds.connect.to('API_BUSINESS_PARTNER');

  srv.on('READ', 'Suppliers', async req => {
      return bupa.run(req.query);
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

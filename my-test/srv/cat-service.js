// cat-service.js
const cds = require('@sap/cds');

module.exports = cds.service.impl(async (srv) => {
  

  // Handler for the assignQuestionsToTest action
  srv.on('assignQuestionsToTest', async (req) => {
    
    console.log("requset data ",req?._params)
    const { questionsCount } = req.data;
    const testId = req._params[0]?.TestID;
    console.log("Test ID:", testId);

    const unassociatedQuestions = await cds.run(
      SELECT.from('my.TestService.Questions').where({ test_TestID: null })
    );
    console.log("unassociatedQuestion ",unassociatedQuestions);


 // Check if there are enough questions to associate
 if (unassociatedQuestions.length >= 0  && unassociatedQuestions.length < questionsCount) {
  console.log(`Not enough unassociated questions available. Available: ${unassociatedQuestions.length}, Requested: ${questionsCount}`);
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

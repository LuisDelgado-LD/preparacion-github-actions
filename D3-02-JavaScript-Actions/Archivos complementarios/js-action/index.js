const core = require('@actions/core');

try {
  // Obtener la entrada 'who-to-greet'
  const nameToGreet = core.getInput('who-to-greet');
  console.log(`Hello ${nameToGreet}!`);

  // Establecer la salida 'greeting-message'
  const message = `Hello again, ${nameToGreet}!`;
  core.setOutput('greeting-message', message);
} catch (error) {
  core.setFailed(error.message);
}

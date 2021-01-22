mm = require('minimatch')

#
# elements
#

promptElem = document.querySelector(".prompt")
resultsElem = document.querySelector(".results")

#
# "load" functionality
#

loadFromQueryParams = ->
  searchParams = new URL(window.location.href).searchParams
  prompt_b64 = searchParams.get("prompt_b64")
  results_b64 = searchParams.get("results_b64")
  if prompt_b64
    promptElem.value = atob(prompt_b64)
  if results_b64
    resultsElem.innerHTML = atob(results_b64)

loadFromQueryParams()
# re-load from query params if location state changes
window.addEventListener('popstate', loadFromQueryParams);

#
# minimatch validation
#

validate = ->
  results = resultsElem.childNodes
  prompt = promptElem.value

  for div in results
    text = div.innerText
    isMatch = mm(text, prompt)
    method = if isMatch then 'add' else 'remove'
    div.classList[method]("match")


validate()

promptElem.addEventListener('keyup', validate);
resultsElem.addEventListener('keyup', validate);



#
# "save" functionality
#

saveAsQueryParams = ->
  prompt = promptElem.value
  results = resultsElem.innerHTML
  # Build search params
  searchParams = new URL(window.location.href).searchParams
  searchParams.set("prompt_b64", btoa(prompt))
  searchParams.set("results_b64", btoa(results))
  # Clear location has, set to new params
  window.history.pushState( {} , prompt, "/?" + searchParams.toString() );

saveElem = document.querySelector(".save")
saveElem.addEventListener("click", saveAsQueryParams)


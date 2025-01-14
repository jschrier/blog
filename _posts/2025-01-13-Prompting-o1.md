---
title: "Prompting O1"
date: 2025-01-13
tags: o1 gpt4 llm
---

Notes on the [Deeplearning.ai Reasoning with o1 course](https://www.deeplearning.ai/short-courses/reasoning-with-o1/)...

(tl;dr---a few good ideas and examples, but it wasn't amazingly mind-blowing. There are jupyter notebooks provided, but none of the code was particularly complicated; focus is more on the prompts and design patterns.)

# Introduction to o1

- [Documentation on the models](https://platform.openai.com/docs/models#o1)
- Applies chain-of-thought style implemented by hidden "reasoning tokens" by using large-scale reinforcement learning to generate the chain of thought. 
- Reasoning tokens are not passed from one turn to the next. 
- Behind the scenes: Verification by consensus/majority voting


# Prompting o1

1. **Be simple and direct:** Write prompts that are straightforward and concise. 
2. **No explicit CoT required:** No need to include "think step by step" in the prompt ([unlike earlier models]({{ site.baseurl }}{% post_url 2024-01-16-GPT-4-does-acid-(base-chemistry) %})) 
3. **Structure:**  Break complex prompts into sections using delimineters like markdown, XML tags, or quotes.
4. **Show, don't tell:**  Rather than excessive explanation, give a contextual example.

**Example:** A `bad` prompt for o1-mini:

```
Generate a function that outputs the SMILES IDs for all the molecules involved in insulin.
Think through this step by step, and don't skip any steps:"
- Identify all the molecules involve in insulin"
- Make the function"
- Loop through each molecule, outputting each into the function and returning a SMILES ID
Molecules: 
```

(this will give the correct result, but will have the o1 model generating a verbose output description.)

You should get the same result (with less output) using the following "good" prompt:

```
"Generate a function that outputs the SMILES IDs for all the molecules involved in insulin.
```

**Comment:** The python code that is output in the video is wrong!  It doesn't generate any [cysteine linkages](https://www2.gvsu.edu/chm463/diabetes/insulin.html)! 

**Example:**  A customer policy. Provide `<instructions>`, `<policy>` and `<user_quer>` XML tags to separate different types of policies

**Example:**  Legal queries.  Rather than provide a detailed list of rules, just show an example of what you want the output to look like. 

# Planning with o1

**Core idea:**  Generate a plan with o1 and then hand-off to gpt-4o-mini to execute each step.

**Why?** Use superior planning capabilities of o1, but lower cost and latency of 4o-mini.

**How:**

1. Use a message list to store the history accumulated by the gpt-4o-mini model

2. o1 is given a prompt (who are you, what is your goal, what are your tools).  Example:

```
You are a supply chain management assistant. The first input you will receive will be a complex task that needs to be carefully reasoned through to solve. 
Your task is to review the challenge, and create a detailed plan to process customer orders, manage inventory, and handle logistics.

You will have access to an LLM agent that is responsible for executing the plan that you create and will return results.

The LLM agent has access to the following functions:
...
```

3. Define the gpt-4o-mini system prompt (standard kind of [ReAct pattern]({{ site.baseurl }}{% post_url 2024-01-13-Implementing-the-ReAct-LLM-Agent-pattern-the-hard-way-and-the-easy-way %}))

```
You are a helpful assistant responsible for executing the policy on handling incoming orders. Your task is to follow the policy exactly as it is written and perform the necessary actions.

You must explain your decision-making process across various steps.

# Steps

1. **Read and Understand Policy**: Carefully read and fully understand the given policy on handling incoming orders.
2. **Identify the exact step in the policy**: Determine which step in the policy you are at, and execute the instructions according to the policy.
3. **Decision Making**: Briefly explain your actions and why you are performing them.
4. **Action Execution**: Perform the actions required by calling any relevant functions and input parameters.

POLICY:
{policy}
```
(observe how we are giving the gpt-4o-mini model explicit chain of thought prompting)

5. Provide gpt-4o-mini with the function calls it need

6. Knit them together, process the list of messages:

```
def process_scenario(scenario):
    append_message({'type': 'status', 'message': 'Generating plan...'})

    plan = call_o1(scenario)

    append_message({'type': 'plan', 'content': plan})

    append_message({'type': 'status', 'message': 'Executing plan...'})

    messages = call_gpt4o(plan)

    append_message({'type': 'status', 'message': 'Processing complete.'})

    return messages
```

# Coding with o1 

**Example:** generating a [react](https://react.dev) app.

**Example:** Improve this code (`I have some code that I'd like you to clean up and improve. Return only the updated code that fixes the issues: {code_snippet}`)

**Example:** Using o1 as a grader to compare two codes. (`which code is better and why? Option 1: {gpt_code}... or Option 2: {o1_code}` )

# Reasoning with images

**Pattern:** Use o1 to extract a JSON representation of a flow-chart  (`You are a consulting assistant who processes org data. Extract the or hierarchy. Return in JSON containing ...`) and then you can use a text-only query to interpret those results.

# Meta-prompting

**Premise:**  Use o1 to generate instructions for gpt-4o by using some human knowledgebase articles.  Evaluate the results.  Provide the eval results to o1 which will try to improve the prompts.  Iterate. 

**Example:**  Make a set of instructions very explicit for a simpler model.  Conversion prompt:

```
You are a helpful assistant tasked with taking an external facing help center article and converting it into a internal-facing programmatically executable routine optimized for an LLM. 
The LLM using this routine will be tasked with reading the policy, answering incoming questions from customers, and helping drive the case toward resolution.

Please follow these instructions:
1. **Review the customer service policy carefully** to ensure every step is accounted for. It is crucial not to skip any steps or policies.
2. **Organize the instructions into a logical, step-by-step order**, using the specified format. 
3. **Use the following format**:
   - **Main actions are numbered** (e.g., 1, 2, 3).
   - **Sub-actions are lettered** under their relevant main actions (e.g., 1a, 1b).
      **Sub-actions should start on new lines**
   - **Specify conditions using clear 'if...then...else' statements** (e.g., 'If the product was purchased within 30 days, then...').
   - **For instructions that require more information from the customer**, provide polite and professional prompts to ask for additional information.
   - **For actions that require data from external systems**, write a step to call a function using backticks for the function name (e.g., call the `check_delivery_date` function).
      - **If a step requires the customer service agent to take an action** (e.g., process a refund), generate a function call for this action (e.g., call the `process_refund` function).
      - **Only use the available set of functions that are defined below.
   - **If there is an action an assistant can perform on behalf of the user**, include a function call for this action (e.g., call the `change_email_address` function), and ensure the function is defined with its purpose and required parameters.
      - **Only use the available set of functions that are defined below.
   - **The step prior to case resolution should always be to ask if there is anything more you can assist with**.
   - **End with a final action for case resolution**: calling the `case_resolution` function should always be the final step.
4. **Ensure compliance** by making sure all steps adhere to company policies, privacy regulations, and legal requirements.
5. **Handle exceptions or escalations** by specifying steps for scenarios that fall outside the standard policy.
6. **Ensure coverage** by checking that all of the conditions covered in the policy are also covered in the routines

**Important**: Always wrap the functions you return in backticks i.e. `check_ticket_type`. Do not include the arguments to the functions.

Here are the currently available set of functions in JSON format: 
TOOLS: {TOOLS}

Please convert the following customer service policy into the formatted routine, ensuring it is easy to follow and execute programmatically. Ensure that you **only** use the functions provided and do **not** create net new functions.
```

**Observation:** It is useful to include some text-based (regex) sanity checks that it is not hallucinating function calls, etc. 

**In the example:** Define a synthetic customer which also generates synthetic tool call responses. Use this to generate the eval. Then improve the results with o1 using the following prompt:

```
# Instructions
You are an agent that is responsible for improving the quality of instructions that are provided to a customer service LLM agent. 
Your task is to improve the instructions that are provided to the LLM agent in order to increase accuracy on a test set while adhering to the initial policy. 

## Criteria
- Analyze the existing instructions and the results of the eval. Understand which behaviors lead to failures.
- For example, if the LLM agent is not asking for the booking reference when it is needed, you should add a step to ask for the booking reference.
- Improve the instructions to address the gaps in the eval results.
- Ensure changes made are compliant with the original policy.
- Only use the tools provided.
- Use the functions provided to the best of your ability to ensure the LLM agent can handle the customer service requests effectively. Including gathering data where necessary.
- Try changing the format if this formatting doesn't work well - consider basic XML (e.g. <step> <substep> <if> <case>) or markdown as alternatives.

You will be provided with 4 items:
1) The ground-truth policy for the customer service agent containing detailed instructions on how to handle flight cancellations and changes.
2) Full list of available functions.
3) A routine instruction set.
4) A results that shows the LLMs performance on a test set using this routine instruction set. This dataset contains columns showing:
    - request: This is the initial user request. 
    - expected_function: This is the function we expect the LLM to call at the end of the conversation. 
    - expected_input: This is the input we expect the LLM to provide to the function at the end of the conversation.
    - actual_function: This is the final function the LLM called using the current instructions.
    - actual_input: These are the function parameters the LLM provided based on the current instructions.
    - transcript: This is the conversation transcript between the user and the LLM agent. 
    - is_correct: True/False value depending on if the model responded correctly

You may be provided with a history of edits and evaluations. You can use this information to understand what has been tried before and what has worked or not worked.

# Data

## 1. Original policy
{flight_cancellation_policy}

## 2. Functions
{TOOLS}

# Conclusion

Return the improved policy exactly as written within the defined JSON. Remove all parts from the LLM's answer that are not part of the policy, and do not create additional keys.

```





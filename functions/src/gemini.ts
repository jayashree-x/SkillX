import { GoogleGenAI, Type } from "@google/genai";
import { defineSecret } from "firebase-functions/params";

// Set with: firebase functions:secrets:set GEMINI_API_KEY
// (Google AI Studio key — https://aistudio.google.com/apikey — set a quota cap.)
export const GEMINI_API_KEY = defineSecret("GEMINI_API_KEY");

export interface GeneratedQuestion {
  questionText: string;
  options: string[]; // exactly 4
  correctIndex: number; // 0..3
}

// QUIZ-15: difficulty must reflect the selected level.
const LEVEL_GUIDANCE: Record<string, string> = {
  BASIC: "definitions and recall",
  BEGINNER: "simple application",
  INTERMEDIATE: "analysis and comparison",
  ADVANCED: "problem-solving and edge cases",
};

/**
 * QUIZ-01/13, POST-05: generate 5 MCQs from the covered subtopics + level via
 * the Gemini API, using a response schema so the JSON is structurally valid.
 */
export async function generateQuizQuestions(input: {
  topic: string;
  coveredSubtopics: string[];
  level: string;
}): Promise<GeneratedQuestion[]> {
  const ai = new GoogleGenAI({ apiKey: GEMINI_API_KEY.value() });
  const difficulty = LEVEL_GUIDANCE[input.level] ?? "application";

  const prompt =
    `Write exactly 10 multiple-choice questions that check understanding of ` +
    `"${input.topic}". Cover only these topics: ${input.coveredSubtopics.join(", ")}. ` +
    `Difficulty: ${input.level} — ${difficulty}. Each question has exactly 4 options ` +
    `and exactly one correct answer. Spread the questions across the topics rather ` +
    `than clustering on one. Return a JSON array of exactly 10 objects, each with ` +
    `{ questionText: string, options: [4 strings], correctIndex: 0-3 }.`;

  const response = await ai.models.generateContent({
    model: "gemini-flash-latest",
    contents: prompt,
    config: {
      // Structured output — Gemini validates the response against this schema.
      responseMimeType: "application/json",
      responseSchema: {
        type: Type.ARRAY,
        items: {
          type: Type.OBJECT,
          properties: {
            questionText: { type: Type.STRING },
            options: { type: Type.ARRAY, items: { type: Type.STRING } },
            correctIndex: { type: Type.INTEGER },
          },
          required: ["questionText", "options", "correctIndex"],
          propertyOrdering: ["questionText", "options", "correctIndex"],
        },
      },
      temperature: 0.7,
      // Flash "thinking" isn't needed for this constrained task — off for speed.
      thinkingConfig: { thinkingBudget: 0 },
    },
  });

  const text = response.text;
  if (!text) throw new Error("No quiz content returned.");

  const parsed = JSON.parse(text) as GeneratedQuestion[];
  const questions = (parsed ?? [])
    .filter(
      (q) =>
        typeof q.questionText === "string" &&
        Array.isArray(q.options) &&
        q.options.length === 4 &&
        q.correctIndex >= 0 &&
        q.correctIndex <= 3,
    )
    .slice(0, 10);

  if (questions.length < 10) {
    throw new Error("Model returned fewer than 10 valid questions.");
  }
  return questions;
}

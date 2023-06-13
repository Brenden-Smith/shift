import {initializeApp} from "firebase-admin/app";
import {getAuth} from "firebase-admin/auth";
import {getFirestore} from "firebase-admin/firestore";
import * as logger from "firebase-functions/logger";
import {onCall, HttpsError} from "firebase-functions/v2/https";

initializeApp();

export const createUser = onCall(async (request) => {
  // Parse request
  const {
    displayName,
    email,
    medicID,
    role,
  } = request.data;

  // Validate request
  if (!request.auth?.uid) {
    logger.warn("User must be authenticated", request.auth?.uid);
    throw new HttpsError("unauthenticated", "User must be authenticated");
  }
  const caller = await getFirestore()
    .collection("users")
    .doc(request.auth.uid)
    .get();
  if (caller.data()?.role !== "admin") {
    logger.warn("User must be an admin", caller.id);
    throw new HttpsError("permission-denied", "User must be an admin");
  } else if (!displayName || !email || !medicID || !role) {
    logger.warn("Missing required fields", request.data);
    throw new HttpsError("invalid-argument", "Missing required fields");
  }

  // Create user
  const user = await getAuth().createUser({
    displayName,
    email,
  });

  // Create user document
  await getFirestore().collection("users").doc(user.uid).set({
    displayName,
    email,
    company: caller.data()?.company,
    medicID,
    role,
    onboarded: false,
  });

  // Resolve
  logger.info(`User ${user.uid} created`);
  return user.uid;
});


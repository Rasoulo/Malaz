<?php

return [

    // 'user.created_pending' => 'Utilisateur créé, veuillez attendre l’approbation des responsables',

    // Téléphone
    'phone.required' => 'Le numéro de téléphone est requis.',
    'phone.regex' => 'Le numéro de téléphone doit être dans un format valide (9–15 chiffres, peut commencer par +).',
    'phone.exists' => 'Ce numéro de téléphone n’existe pas dans nos dossiers.',
    'phone.unique' => 'Ce numéro de téléphone est déjà enregistré.',
    'phone.doesnotmatch' => 'Le numéro de téléphone que vous avez saisi ne correspond pas au numéro enregistré sur votre compte.',


    // Mot de passe
    'password.required' => 'Le mot de passe est requis.',
    'password.string' => 'Le mot de passe doit être une chaîne valide.',
    'password.min' => 'Le mot de passe doit contenir au moins 6 caractères.',
    'password.confirmed' => 'La confirmation du mot de passe ne correspond pas.',

    // Noms
    'first_name.required' => 'Le prénom est requis.',
    'first_name.string' => 'Le prénom doit être une chaîne valide.',
    'last_name.required' => 'Le nom de famille est requis.',
    'last_name.string' => 'Le nom de famille doit être une chaîne valide.',

    // Carte d’identité
    'identity_card_image.required' => 'L’image de la carte d’identité est requise.',
    'identity_card_image.file' => 'L’image de la carte d’identité doit être un fichier.',
    'identity_card_image.image' => 'L’image de la carte d’identité doit être une image.',
    'identity_card_image.mimes' => 'L’image de la carte d’identité doit être de type : jpeg, png, jpg, gif, svg.',
    'identity_card_image.max' => 'L’image de la carte d’identité ne doit pas dépasser 10MB.',

    // Photo de profil
    'profile_image.required' => 'La photo de profil est requise.',
    'profile_image.file' => 'La photo de profil doit être un fichier.',
    'profile_image.image' => 'La photo de profil doit être une image.',
    'profile_image.mimes' => 'La photo de profil doit être de type : jpeg, png, jpg, gif, svg.',
    'profile_image.max' => 'La photo de profil ne doit pas dépasser 10MB.',

    // Date de naissance
    'date_of_birth.required' => 'La date de naissance est requise.',
    'date_of_birth.date' => 'La date de naissance doit être une date valide.',
    'date_of_birth.before' => 'Vous devez avoir au moins 6 ans.',

    // Propriété
    'property_id.required' => 'L’identifiant de la propriété est requis.',
    'property_id.integer' => 'L’identifiant de la propriété doit être un entier.',
    'property_id.exists' => 'La propriété sélectionnée n’existe pas.',

    // Prix
    'price.required' => 'Le prix est requis.',
    'price.integer' => 'Le prix doit être un entier.',
    'price.min' => 'Le prix doit être au moins 0.',

    // Ville
    'city.required' => 'La ville est requise.',
    'city.string' => 'La ville doit être une chaîne valide.',
    'city.max' => 'La ville ne doit pas dépasser 255 caractères.',

    // Adresse
    'address.required' => 'L’adresse est requise.',
    'address.string' => 'L’adresse doit être une chaîne valide.',
    'address.max' => 'L’adresse ne doit pas dépasser 255 caractères.',

    // Gouvernorat
    'governorate.required' => 'Le gouvernorat est requis.',
    'governorate.string' => 'Le gouvernorat doit être une chaîne valide.',
    'governorate.max' => 'Le gouvernorat ne doit pas dépasser 255 caractères.',

    // Coordonnées
    'latitude.numeric' => 'La latitude doit être un nombre valide.',
    'longitude.numeric' => 'La longitude doit être un nombre valide.',

    // Description
    'description.string' => 'La description doit être une chaîne valide.',
    'description.max' => 'La description ne doit pas dépasser 1000 caractères.',

    // Images
    'images.array' => 'Les images doivent être un tableau.',
    'images.*.file' => 'Chaque image doit être un fichier valide.',
    'images.*.image' => 'Chaque fichier doit être une image.',
    'images.*.mimes' => 'Les images doivent être de type : jpeg, png, jpg, gif, svg.',
    'images.*.max' => 'Chaque image ne doit pas dépasser 10MB.',

    // Effacement
    'erase.array' => 'Le champ effacer doit être un tableau.',
    'erase.*.integer' => 'Chaque élément à effacer doit être un entier.',

    // Type
    'type.required' => 'Le type est requis.',
    'type.string' => 'Le type doit être une chaîne valide.',
    'type.in' => 'Le type doit être l’un de : Appartement, Ferme, Villa, Maison, Maison de campagne.',

    // Pièces
    'number_of_rooms.required' => 'Le nombre de pièces est requis.',
    'number_of_rooms.integer' => 'Le nombre de pièces doit être un entier.',
    'number_of_rooms.min' => 'Le nombre de pièces doit être au moins 0.',

    // Salles de bain
    'number_of_baths.required' => 'Le nombre de salles de bain est requis.',
    'number_of_baths.integer' => 'Le nombre de salles de bain doit être un entier.',
    'number_of_baths.min' => 'Le nombre de salles de bain doit être au moins 0.',

    // Chambres
    'number_of_bedrooms.required' => 'Le nombre de chambres est requis.',
    'number_of_bedrooms.integer' => 'Le nombre de chambres doit être un entier.',
    'number_of_bedrooms.min' => 'Le nombre de chambres doit être au moins 0.',

    // Surface
    'area.required' => 'La surface est requise.',
    'area.numeric' => 'La surface doit être un nombre valide.',
    'area.min' => 'La surface doit être au moins 0.',

    // Titre
    'title.required' => 'Le champ titre est requis.',
    'title.string' => 'Le titre doit être une chaîne valide.',
    'title.max' => 'Le titre ne doit pas dépasser 255 caractères.',

    // Champs interdits
    'status.prohibited' => 'Le champ statut ne peut pas être défini manuellement.',
    'rating.prohibited' => 'Le champ évaluation ne peut pas être défini manuellement.',
    'number_of_reviews.prohibited' => 'Le champ nombre d’avis ne peut pas être défini manuellement.',

    // Image principale
    'main_pic.file' => 'L’image principale doit être un fichier valide.',
    'main_pic.image' => 'L’image principale doit être une image.',
    'main_pic.mimes' => 'L’image principale doit être de type : jpeg, png, jpg, gif, svg.',
    'main_pic.max' => 'L’image principale ne doit pas dépasser 10MB.',

    'conversation' => [
        'self_start' => 'Vous ne pouvez pas commencer une conversation avec vous-même',
        'created' => 'Conversation créée avec succès',
        'exists' => 'La conversation existe déjà',
        'unauthorized' => 'Non autorisé',
        'show' => 'Voici votre conversation',
        'deleted' => 'Conversation supprimée avec succès',
    ],

    'edit_request' => [
        'all_retrieved' => 'Toutes les demandes de modification ont été récupérées avec succès',
        'pending_retrieved' => 'Les demandes de modification en attente ont été récupérées avec succès',
        'updated' => 'Demande de modification mise à jour avec succès',
    ],

    'message' => [
        'unauthorized' => 'Non autorisé',
        'created' => 'Message créé avec succès',
        'retrieved' => 'Message récupéré avec succès',
        'updated' => 'Message mis à jour avec succès',
        'not_sender' => 'Vous n’êtes pas l’expéditeur',
        'cannot_mark_own' => 'Vous ne pouvez pas marquer votre propre message comme lu',
        'marked_read' => 'Message marqué comme lu',
        'deleted' => 'Message supprimé avec succès',
        'delete_failed' => 'Échec de la suppression du message',
    ],

    'property' => [
        'my_list' => 'Voici toutes vos propriétés',
        'all_list' => 'Voici toutes les propriétés',
        'created' => 'Propriété créée avec succès',
        'not_approved' => 'Propriété non approuvée',
        'returned' => 'Propriété renvoyée avec succès',
        'not_found' => 'Propriété introuvable',
        'favorited_by' => 'Toutes ces personnes aiment cette propriété',
        'updated' => 'Propriété mise à jour avec succès',
        'deleted' => 'Propriété supprimée avec succès',
    ],

    'review' => [
        'all_user_reviews' => 'Voici toutes vos évaluations',
        'require_rating_or_body' => 'Il doit y avoir au moins une [note ou texte] pour l’évaluation',
        'already_reviewed' => 'Vous avez déjà évalué cette propriété.',
        'published' => 'L’évaluation a été publiée avec succès',
        'must_reserve_before' => 'Il est nécessaire de réserver cet appartement avant de laisser une évaluation.',
        'property_reviews' => 'Voici les évaluations de la propriété',
        'unauthorized' => 'Non autorisé',
        'updated' => 'Évaluation mise à jour avec succès',
        'deleted' => 'Évaluation supprimée avec succès',
    ],

    'user' => [
        'list' => 'Liste de tous les utilisateurs',
        'added_favorite' => 'Ajouté aux favoris avec succès',
        'removed_favorite' => 'Supprimé des favoris avec succès',
        'favorite_list' => 'Voici votre liste de favoris',
        'otp_sent' => 'Code OTP envoyé avec succès',
        'otp_expired' => 'Le code OTP a expiré ou est introuvable',
        'otp_invalid' => 'Code OTP invalide',
        'phone_verified' => 'Téléphone vérifié avec succès',
        'updated' => 'Utilisateur mis à jour avec succès',
        'edit_request_sent' => 'Demande de modification envoyée, veuillez attendre l’approbation des responsables',
        'language_updated' => 'Langue mise à jour avec succès',
        'try_another_image' => 'Essayez une autre image',
        'created_pending' => 'Utilisateur créé, veuillez attendre l’approbation des responsables',
        'password_incorrect' => 'Mot de passe actuel incorrect',
        'password_updated' => 'Mot de passe mis à jour avec succès',
        'invalid_credentials' => 'Identifiants invalides',
        'not_found' => 'Utilisateur introuvable',
        'pending_approval' => 'Veuillez attendre l’approbation des responsables',
        'token_failed' => 'Échec de la création du jeton',
        'logged_out' => 'Déconnexion réussie',
    ],

    'bookings' => [
        'returned' => 'Les réservations confirmées ont été renvoyées avec succès.',
    ],
];
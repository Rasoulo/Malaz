<?php

return [
    // Telefon
    'phone.required' => 'Telefon numarası gereklidir.',
    'phone.regex' => 'Telefon numarası geçerli bir formatta olmalıdır (9–15 rakam, + ile başlayabilir).',
    'phone.exists' => 'Bu telefon numarası kayıtlarımızda bulunmamaktadır.',
    'phone.unique' => 'Bu telefon numarası zaten kayıtlı.',

    // Şifre
    'password.required' => 'Şifre gereklidir.',
    'password.string' => 'Şifre geçerli bir metin olmalıdır.',
    'password.min' => 'Şifre en az 6 karakter olmalıdır.',
    'password.confirmed' => 'Şifre doğrulaması eşleşmiyor.',

    // İsimler
    'first_name.required' => 'Ad gereklidir.',
    'first_name.string' => 'Ad geçerli bir metin olmalıdır.',
    'last_name.required' => 'Soyad gereklidir.',
    'last_name.string' => 'Soyad geçerli bir metin olmalıdır.',

    // Kimlik kartı
    'identity_card_image.required' => 'Kimlik kartı resmi gereklidir.',
    'identity_card_image.file' => 'Kimlik kartı resmi bir dosya olmalıdır.',
    'identity_card_image.image' => 'Kimlik kartı resmi bir resim olmalıdır.',
    'identity_card_image.mimes' => 'Kimlik kartı resmi şu türlerden biri olmalıdır: jpeg, png, jpg, gif, svg.',
    'identity_card_image.max' => 'Kimlik kartı resmi 2MB\'ı geçmemelidir.',

    // Profil resmi
    'profile_image.required' => 'Profil resmi gereklidir.',
    'profile_image.file' => 'Profil resmi bir dosya olmalıdır.',
    'profile_image.image' => 'Profil resmi bir resim olmalıdır.',
    'profile_image.mimes' => 'Profil resmi şu türlerden biri olmalıdır: jpeg, png, jpg, gif, svg.',
    'profile_image.max' => 'Profil resmi 2MB\'ı geçmemelidir.',

    // Doğum tarihi
    'date_of_birth.required' => 'Doğum tarihi gereklidir.',
    'date_of_birth.date' => 'Doğum tarihi geçerli bir tarih olmalıdır.',
    'date_of_birth.before' => 'En az 6 yaşında olmalısınız.',

    // Mülk
    'property_id.required' => 'Mülk kimliği gereklidir.',
    'property_id.integer' => 'Mülk kimliği bir tam sayı olmalıdır.',
    'property_id.exists' => 'Seçilen mülk mevcut değil.',

    // Fiyat
    'price.required' => 'Fiyat gereklidir.',
    'price.integer' => 'Fiyat bir tam sayı olmalıdır.',
    'price.min' => 'Fiyat en az 0 olmalıdır.',

    // Şehir
    'city.required' => 'Şehir gereklidir.',
    'city.string' => 'Şehir geçerli bir metin olmalıdır.',
    'city.max' => 'Şehir 255 karakteri geçmemelidir.',

    // Adres
    'address.required' => 'Adres gereklidir.',
    'address.string' => 'Adres geçerli bir metin olmalıdır.',
    'address.max' => 'Adres 255 karakteri geçmemelidir.',

    // İl
    'governorate.required' => 'İl gereklidir.',
    'governorate.string' => 'İl geçerli bir metin olmalıdır.',
    'governorate.max' => 'İl 255 karakteri geçmemelidir.',

    // Koordinatlar
    'latitude.numeric' => 'Enlem geçerli bir sayı olmalıdır.',
    'longitude.numeric' => 'Boylam geçerli bir sayı olmalıdır.',

    // Açıklama
    'description.string' => 'Açıklama geçerli bir metin olmalıdır.',
    'description.max' => 'Açıklama 1000 karakteri geçmemelidir.',

    // Resimler
    'images.array' => 'Resimler bir dizi olmalıdır.',
    'images.*.file' => 'Her resim geçerli bir dosya olmalıdır.',
    'images.*.image' => 'Her dosya bir resim olmalıdır.',
    'images.*.mimes' => 'Resimler şu türlerden biri olmalıdır: jpeg, png, jpg, gif, svg.',
    'images.*.max' => 'Her resim 2MB\'ı geçmemelidir.',

    // Silme
    'erase.array' => 'Silme alanı bir dizi olmalıdır.',
    'erase.*.integer' => 'Her silme öğesi bir tam sayı olmalıdır.',

    // Tür
    'type.required' => 'Tür gereklidir.',
    'type.string' => 'Tür geçerli bir metin olmalıdır.',
    'type.in' => 'Tür şu seçeneklerden biri olmalıdır: Daire, Çiftlik, Villa, Restoran, Yol kenarı dinlenme tesisi, Konut kulesi, Kırsal mülk.',

    // Odalar
    'number_of_rooms.required' => 'Oda sayısı gereklidir.',
    'number_of_rooms.integer' => 'Oda sayısı bir tam sayı olmalıdır.',
    'number_of_rooms.min' => 'Oda sayısı en az 0 olmalıdır.',

    // Banyolar
    'number_of_baths.required' => 'Banyo sayısı gereklidir.',
    'number_of_baths.integer' => 'Banyo sayısı bir tam sayı olmalıdır.',
    'number_of_baths.min' => 'Banyo sayısı en az 0 olmalıdır.',

    // Yatak odaları
    'number_of_bedrooms.required' => 'Yatak odası sayısı gereklidir.',
    'number_of_bedrooms.integer' => 'Yatak odası sayısı bir tam sayı olmalıdır.',
    'number_of_bedrooms.min' => 'Yatak odası sayısı en az 0 olmalıdır.',

    // Alan
    'area.required' => 'Alan gereklidir.',
    'area.numeric' => 'Alan geçerli bir sayı olmalıdır.',
    'area.min' => 'Alan en az 0 olmalıdır.',

    // Başlık
    'title.required' => 'Başlık alanı gereklidir.',
    'title.string' => 'Başlık geçerli bir metin olmalıdır.',
    'title.max' => 'Başlık 255 karakteri geçmemelidir.',

    // Yasaklı alanlar
    'status.prohibited' => 'Durum alanı manuel olarak ayarlanamaz.',
    'rating.prohibited' => 'Derecelendirme alanı manuel olarak ayarlanamaz.',
    'number_of_reviews.prohibited' => 'Yorum sayısı alanı manuel olarak ayarlanamaz.',

    // Ana resim
    'main_pic.file' => 'Ana resim geçerli bir dosya olmalıdır.',
    'main_pic.image' => 'Ana resim bir resim olmalıdır.',
    'main_pic.mimes' => 'Ana resim şu türlerden biri olmalıdır: jpeg, png, jpg, gif, svg.',
    'main_pic.max' => 'Ana resim 2MB\'ı geçmemelidir.',

    'conversation' => [
        'self_start' => 'Kendi kendinizle sohbet başlatamazsınız',
        'created' => 'Sohbet başarıyla oluşturuldu',
        'exists' => 'Sohbet zaten mevcut',
        'unauthorized' => 'Yetkisiz erişim',
        'show' => 'İşte sohbetiniz',
        'deleted' => 'Sohbet başarıyla silindi',
    ],

    'edit_request' => [
        'all_retrieved' => 'Tüm düzenleme talepleri başarıyla getirildi',
        'pending_retrieved' => 'Bekleyen düzenleme talepleri başarıyla getirildi',
        'updated' => 'Düzenleme talebi başarıyla güncellendi',
    ],

    'message' => [
        'unauthorized' => 'Yetkisiz erişim',
        'created' => 'Mesaj başarıyla oluşturuldu',
        'retrieved' => 'Mesaj başarıyla getirildi',
        'updated' => 'Mesaj başarıyla güncellendi',
        'not_sender' => 'Gönderen siz değilsiniz',
        'cannot_mark_own' => 'Kendi mesajınızı okundu olarak işaretleyemezsiniz',
        'marked_read' => 'Mesaj okundu olarak işaretlendi',
        'deleted' => 'Mesaj başarıyla silindi',
        'delete_failed' => 'Mesaj silinemedi',
    ],

    'property' => [
        'my_list' => 'İşte tüm mülkleriniz',
        'all_list' => 'İşte tüm mülkler',
        'created' => 'Mülk başarıyla oluşturuldu',
        'not_approved' => 'Mülk onaylanmadı',
        'returned' => 'Mülk başarıyla getirildi',
        'not_found' => 'Mülk bulunamadı',
        'favorited_by' => 'Bu mülkü seven tüm kullanıcılar',
        'updated' => 'Mülk başarıyla güncellendi',
        'deleted' => 'Mülk başarıyla silindi',
    ],

    'review' => [
        'all_user_reviews' => 'İşte tüm yorumlarınız',
        'require_rating_or_body' => 'Yorum için en az [puan veya metin] olmalıdır',
        'already_reviewed' => 'Bu mülkü zaten değerlendirdiniz.',
        'published' => 'Yorum başarıyla yayınlandı',
        'must_reserve_before' => 'Yorum yapmadan önce bu daireyi rezerve etmeniz gerekir.',
        'property_reviews' => 'İşte mülk yorumları',
        'unauthorized' => 'Yetkisiz erişim',
        'updated' => 'Yorum başarıyla güncellendi',
        'deleted' => 'Yorum başarıyla silindi',
    ],

    'user' => [
        'list' => 'Tüm kullanıcıların listesi',
        'added_favorite' => 'Favorilere başarıyla eklendi',
        'removed_favorite' => 'Favorilerden başarıyla kaldırıldı',
        'favorite_list' => 'İşte favori listeniz',
        'otp_sent' => 'OTP kodu başarıyla gönderildi',
        'otp_expired' => 'OTP kodunun süresi doldu veya bulunamadı',
        'otp_invalid' => 'Geçersiz OTP kodu',
        'phone_verified' => 'Telefon başarıyla doğrulandı',
        'updated' => 'Kullanıcı başarıyla güncellendi',
        'edit_request_sent' => 'Düzenleme talebi gönderildi, yetkililerin onayını bekleyin',
        'language_updated' => 'Dil başarıyla güncellendi',
        'try_another_image' => 'Başka bir resim deneyin',
        'created_pending' => 'Kullanıcı oluşturuldu, yetkililerin onayını bekleyin',
        'password_incorrect' => 'Mevcut şifre yanlış',
        'password_updated' => 'Şifre başarıyla güncellendi',
        'invalid_credentials' => 'Geçersiz kimlik bilgileri',
        'not_found' => 'Kullanıcı bulunamadı',
        'pending_approval' => 'Yetkililerin onayını bekleyin',
        'token_failed' => 'Token oluşturulamadı',
        'logged_out' => 'Başarıyla çıkış yapıldı',
    ],
];
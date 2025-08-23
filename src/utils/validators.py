"""Валидаторы для входящих данных."""
import re
from typing import Tuple, Optional


class MessageValidator:
    """Класс для валидации сообщений пользователей."""
    
    # Константы
    MAX_MESSAGE_LENGTH = 4000  # Чуть меньше лимита Telegram (4096)
    MIN_MESSAGE_LENGTH = 1
    MAX_EMOJI_COUNT = 50
    
    @classmethod
    def validate_user_message(cls, message: str) -> Tuple[bool, Optional[str]]:
        """
        Валидация сообщения пользователя.
        
        Args:
            message: Текст сообщения для валидации
            
        Returns:
            Tuple[bool, Optional[str]]: (is_valid, error_message)
        """
        if not message or not message.strip():
            return False, "empty"
        
        # Проверка длины
        if len(message) > cls.MAX_MESSAGE_LENGTH:
            return False, "too_long"
        
        # Проверка на слишком много эмодзи
        emoji_count = cls._count_emojis(message)
        if emoji_count > cls.MAX_EMOJI_COUNT:
            return False, "too_many_emojis"
        
        # Проверка на спам (повторяющиеся символы)
        if cls._is_spam_message(message):
            return False, "spam"
        
        return True, None
    
    @classmethod
    def _count_emojis(cls, text: str) -> int:
        """Подсчет количества эмодзи в тексте."""
        emoji_pattern = re.compile(
            "["
            "\U0001F600-\U0001F64F"  # emoticons
            "\U0001F300-\U0001F5FF"  # symbols & pictographs
            "\U0001F680-\U0001F6FF"  # transport & map symbols
            "\U0001F1E0-\U0001F1FF"  # flags (iOS)
            "\U00002702-\U000027B0"
            "\U000024C2-\U0001F251"
            "]+",
            flags=re.UNICODE
        )
        return len(emoji_pattern.findall(text))
    
    @classmethod
    def _is_spam_message(cls, text: str) -> bool:
        """Проверка на спам (повторяющиеся символы)."""
        # Проверяем, если один символ повторяется более 20 раз подряд
        if re.search(r'(.)\1{19,}', text):
            return True
        
        # Проверяем, если сообщение состоит из одних и тех же слов
        words = text.lower().split()
        if len(words) > 5:
            unique_words = set(words)
            if len(unique_words) / len(words) < 0.3:  # Менее 30% уникальных слов
                return True
        
        return False
    
    @classmethod
    def get_validation_error_message(cls, error_type: str) -> str:
        """Получить саркастическое сообщение об ошибке валидации."""
        messages = {
            "empty": (
                "🤔 Интересный подход! Немое общение с ботом. "
                "К сожалению, мой талант чтения мыслей пока в разработке. "
                "Попробуй написать что-нибудь текстом - я специализируюсь именно на этом 'искусстве'."
            ),
            "too_long": (
                "📚 Ого! Ты написал целый роман! Боюсь, мой мозг не приспособлен "
                "к таким литературным шедеврам. Попробуй сократить свои мысли "
                "до размера, который может вместить обычный саркастический бот. "
                f"Максимум {cls.MAX_MESSAGE_LENGTH} символов, пожалуйста."
            ),
            "too_many_emojis": (
                "🎭🎪🎨 Вау! Кажется, у тебя закончились слова и остались только эмодзи! "
                "Хотя это искусство самовыражения, но я предпочитаю старомодные буквы. "
                f"Ограничь себя {cls.MAX_EMOJI_COUNT} эмодзи на сообщение, будь добр."
            ),
            "spam": (
                "🔄 Хм, а это не спам случайно? Повторяющиеся символы или слова - "
                "это конечно оригинальный способ общения, но я больше ценю "
                "разнообразие в мыслях. Попробуй что-нибудь более... творческое!"
            )
        }
        
        return messages.get(error_type, "Что-то пошло не так с твоим сообщением. Попробуй еще раз.")


# Экспорт для удобства
validator = MessageValidator()

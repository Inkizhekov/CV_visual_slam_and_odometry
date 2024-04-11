import subprocess
import os

def process_video_with_openvslam(video_path):
    # Путь к конфигурационному файлу OpenVSLAM
    config_path = '/path/to/openvslam/config.yaml'
    
    # Путь к сохранению карты и траектории
    map_path = '/path/to/save/map.msg'
    trajectory_path = '/path/to/save/trajectory.txt'
    
    # Формирование команды для запуска OpenVSLAM
    command = [
        'openvslam', # или путь к вашему исполняемому файлу OpenVSLAM
        '-v', '/path/to/orb_vocab.dbow2',
        '-c', config_path,
        '-m', video_path,
        '--map-db', map_path,
        '--frame-skip', '3', # Пример параметра, пропуск кадров
        '--no-sleep', '--auto-term',
        '--eval-log'
    ]
    
    # Запуск OpenVSLAM
    result = subprocess.run(command, capture_output=True, text=True)
    
    # Обработка вывода OpenVSLAM (если необходимо)
    print(result.stdout)
    
    # Возвращаем пути к результатам для дальнейшей обработки
    return map_path, trajectory_path
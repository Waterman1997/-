# -*- coding:UTF-8 -*-
'''
作者：CnpPt
创建于 2018年6月11日18:18:14
'''
from bs4 import BeautifulSoup
import requests
if __name__ == '__main__':
    page = int(input('请输入要采集的页数(最多40页)：'))

    print('''
    ---------------磁链采集程序已启动----------------

    ---------------你设置了只采集%d页----------------

    ---------------磁链采集中，请耐心等待。。。

    ''' % (page))
    for num in range(page):
        pagetitle = 50 * num
        url = 'https://anidex.info/?page=user&id=9366&offset=%d' % pagetitle
        headers = {
            "User-Agent": "Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36"
        }
        req = requests.get(url=url, headers=headers)
        req.encoding = 'utf-8'
        html = req.text
        bf = BeautifulSoup(html, 'lxml')
        targets_url = bf.find_all(class_='torrent')
        list_url = []
        for each in targets_url:
            list_url.append('https://anidex.info' + each.get('href'))
        for magnet in list_url:
            req = requests.get(url=magnet, headers=headers)
            req.encoding = 'utf-8'
            html = req.text
            bf = BeautifulSoup(html, 'lxml')
            targets_url = bf.find_all(class_='btn btn-default')
            list_url = []
            for each in targets_url:
                list_url.append(each.get('href'))
            list_url[2] = list_url[2].replace('&tr=http://anidex.moe:6969/announce','')
            print(list_url[2])
            f = open('神奇磁链.txt', 'a', encoding='utf-8')
            f.write(list_url[2] + '\n')
            f.close()
    print('\n---------------采集完成----------------')